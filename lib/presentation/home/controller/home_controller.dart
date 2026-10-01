


import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:mye_commerce/presentation/home/data/all_category_model.dart';
import 'package:mye_commerce/presentation/home/data/all_product_model.dart'
as product_model;

import '../../../core/config/app_url.dart';
import '../../../core/theme/app_color.dart';
import '../../../global/custom_button.dart';
import '../../../global/custom_confirm_dialog.dart';

class HomeController extends GetxController {
  // ========================================================================
  // CATEGORY
  // ========================================================================

  RxString selectedCategoryId = 'All'.obs;

  RxList<product_model.Items> allProduct =
      <product_model.Items>[].obs;

  RxList<Result> allCategories = <Result>[].obs;

  // ========================================================================
  // PAGINATION
  // ========================================================================

  int currentPage = 1;
  final int limit = 10;

  // ========================================================================
  // LOADING
  // ========================================================================

  RxBool isLoading2 = false.obs;
  RxBool isLoading = false.obs;

  // ========================================================================
  // USER
  // ========================================================================

  final userName = "Alex Freeman".obs;

  // ========================================================================
  // LOCATION
  // ========================================================================

  final userLocation = "Fetching location...".obs;

  // ========================================================================
  // SEARCH & SPEECH TO TEXT
  // ========================================================================

  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  final stt.SpeechToText speechToText = stt.SpeechToText();
  final RxBool isListening = false.obs;

  // ========================================================================
  // ON INIT
  // ========================================================================

  @override
  void onInit() {
    super.onInit();

    getCategories();

    getAllProduct();

    debounce(
      searchQuery,
          (_) => getAllProduct(page: 1),
      time: const Duration(milliseconds: 500),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAndRequestLocation();
    });
  }

  // ========================================================================
  // SEARCH METHODS
  // ========================================================================

  void onSearchChanged(String query) {
    searchQuery.value = query.trim();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    getAllProduct(page: 1);
  }

  // ========================================================================
  // REFRESH HOME
  // ========================================================================

  Future<void> onRefreshHome() async {
    currentPage = 1;
    searchController.clear();
    searchQuery.value = '';
    selectedCategoryId.value = 'All';

    await Future.wait([
      getCategories(),
      getAllProduct(page: 1),
    ]);
  }

  // ========================================================================
  // SPEECH TO TEXT METHOD
  // ========================================================================

  Future<void> toggleListening() async {
    if (isListening.value) {
      await speechToText.stop();
      isListening.value = false;
    } else {
      bool available = await speechToText.initialize(
        onError: (error) {
          log("Speech error: $error");
          isListening.value = false;
        },
        onStatus: (status) {
          log("Speech status: $status");

          if (status == 'done' || status == 'notListening') {
            isListening.value = false;
          }
        },
      );

      if (available) {
        isListening.value = true;

        await speechToText.listen(
          onResult: (result) {
            searchController.text = result.recognizedWords;
            onSearchChanged(result.recognizedWords);
          },
        );
      } else {
        isListening.value = false;
        log("Speech recognition not available or permission denied.");
      }
    }
  }

  // ========================================================================
  // GET ALL CATEGORIES
  // ========================================================================

  Future<void> getCategories() async {
    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(AppUrl.getCategories),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic jsonData = jsonDecode(response.body);
        final AllCategory allCategory = AllCategory.fromJson(jsonData);

        allCategories.assignAll(allCategory.result ?? []);
      }
    } catch (e) {
      log('Error fetching categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ========================================================================
  // SELECT CATEGORY & FILTER PRODUCTS
  // ========================================================================

  void selectCategory(String categoryName) {
    selectedCategoryId.value = categoryName;
    getAllProduct(page: 1);
  }

  // ========================================================================
  // LOCATION
  // ========================================================================

  Future<void> checkAndRequestLocation() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      Get.dialog(
        CustomConfirmDialog(
          icon: Icons.location_off_outlined,
          iconColor: Colors.orange,
          title: "Please turn on your device location",
          child: CustomButton(
            text: "Turn On Location",
            backgroundColor: AppColor.drawerGradient1,
            textColor: Colors.white,
            onPressed: () async {
              Get.back();
              await Geolocator.openLocationSettings();
              checkAndRequestLocation();
            },
          ),
        ),
        barrierDismissible: false,
      );
      userLocation.value = "Location service is off";
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // Direct system permission request without custom popup
      permission = await Geolocator.requestPermission();
      _handlePermissionResult(permission);
    } else if (permission == LocationPermission.deniedForever) {
      userLocation.value = "Permission denied";
    } else {
      _getCurrentCity();
    }
  }

  void _handlePermissionResult(LocationPermission permission) {
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _getCurrentCity();
    } else {
      userLocation.value = "Permission denied";
    }
  }

  Future<void> _getCurrentCity() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        userLocation.value = "${place.locality ?? ''}, ${place.country ?? ''}";
      } else {
        userLocation.value = "Location detected";
      }
    } catch (e) {
      userLocation.value = "Unable to get location";
    }
  }

  // ========================================================================
  // GET ALL PRODUCTS / SERVICES
  // ========================================================================

  Future<void> getAllProduct({int page = 1}) async {
    isLoading2.value = true;
    currentPage = page;

    try {
      final Map<String, String> queryParams = {
        'page': '$page',
        'limit': '$limit',
      };

      if (searchQuery.value.isNotEmpty) {
        queryParams['search'] = searchQuery.value;
        queryParams['searchTerm'] = searchQuery.value;
      }

      if (selectedCategoryId.value != 'All') {
        queryParams['category'] = selectedCategoryId.value;
        queryParams['productCategory'] = selectedCategoryId.value;
      }

      final originalUri = Uri.parse(AppUrl.getProducts);
      final Map<String, String> finalQueryParams = Map<String, String>.from(originalUri.queryParameters);
      finalQueryParams.addAll(queryParams);

      final uri = originalUri.replace(queryParameters: finalQueryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final product_model.AllProduct allProducts = product_model.AllProduct.fromJson(jsonData);

        List<product_model.Items> fetchedItems = allProducts.items ?? [];

        // 1. Search Filter
        if (searchQuery.value.isNotEmpty) {
          final query = searchQuery.value.toLowerCase();
          fetchedItems = fetchedItems.where((item) {
            final title = (item.title ?? '').toLowerCase();
            final desc = (item.description ?? '').toLowerCase();
            return title.contains(query) || desc.contains(query);
          }).toList();
        }

        // 2. Category Filter
        if (selectedCategoryId.value != 'All') {
          final selectedCat = selectedCategoryId.value.toLowerCase();
          fetchedItems = fetchedItems.where((item) {
            final itemCat = (item.category ?? '').toLowerCase();
            return itemCat == selectedCat || itemCat.contains(selectedCat);
          }).toList();
        }

        allProduct.assignAll(fetchedItems);
        log("Products fetched and filtered successfully: ${allProduct.length}");

      } else {
        allProduct.clear();
      }
    } catch (e) {
      allProduct.clear();
      log("AllProduct catch error: $e");
    } finally {
      isLoading2.value = false;
    }
  }

  // ========================================================================
  // DISPOSE
  // ========================================================================

  @override
  void onClose() {
    searchController.dispose();
    speechToText.stop();
    super.onClose();
  }
}