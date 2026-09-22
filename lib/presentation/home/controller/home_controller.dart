import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:mye_commerce/core/config/app_url.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_button.dart';
import 'package:mye_commerce/global/custom_confirm_dialog.dart';
import 'package:mye_commerce/presentation/home/data/all_category_model.dart';

class HomeController extends GetxController {
  // ========================================================================
  // CATEGORY
  // ========================================================================

  RxString selectedCategoryId = 'All'.obs;

  RxList<Result> allCategories = <Result>[].obs;

  // ========================================================================
  // LOADING
  // ========================================================================

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
  // SEARCH
  // ========================================================================

  final searchController = TextEditingController();

  // ========================================================================
  // ON INIT
  // ========================================================================

  @override
  void onInit() {
    super.onInit();

    // Get categories from API
    getCategories();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAndRequestLocation();
    });
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

      log(
        'Category API Status Code: ${response.statusCode}',
      );

      log(
        'Category API Response: ${response.body}',
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        log(
          'Categories fetched successfully',
        );

        final Map<String, dynamic> jsonData =
        jsonDecode(response.body);

        final AllCategory allCategory =
        AllCategory.fromJson(jsonData);

        allCategories.value =
            allCategory.result ?? [];

        log(
          'Fetched categories: ${allCategories.length}',
        );
      } else {
        log(
          'Failed to fetch categories. '
              'Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      log(
        'Error fetching categories: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ========================================================================
  // SELECT CATEGORY
  // ========================================================================

  void selectCategory(String categoryId) {
    selectedCategoryId.value = categoryId;

    log(
      'Selected Category ID: $categoryId',
    );

    if (categoryId == 'All') {
      log('Selected category: All');
      return;
    }

    final Result? category =
    allCategories.firstWhereOrNull(
          (item) => item.id == categoryId,
    );

    log(
      'Selected category: ${category?.name}',
    );
  }

  // ========================================================================
  // LOCATION
  // ========================================================================

  Future<void> checkAndRequestLocation() async {
    // ================================================================
    // CHECK LOCATION SERVICE
    // ================================================================

    bool isLocationServiceEnabled =
    await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      Get.dialog(
        CustomConfirmDialog(
          icon: Icons.location_off_outlined,
          iconColor: Colors.orange,
          title:
          "Please turn on your device location",
          child: CustomButton(
            text: "Turn On Location",
            backgroundColor:
            AppColor.drawerGradient1,
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

      userLocation.value =
      "Location service is off";

      return;
    }

    // ================================================================
    // CHECK PERMISSION
    // ================================================================

    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      Get.dialog(
        CustomConfirmDialog(
          icon: Icons.location_on_outlined,
          iconColor: AppColor.primary,
          title:
          "Allow location access to find products near you",
          child: CustomButton(
            text: "Allow Location",
            backgroundColor:
            AppColor.drawerGradient1,
            textColor: Colors.white,
            onPressed: () async {
              Get.back();

              permission =
              await Geolocator.requestPermission();

              _handlePermissionResult(
                permission,
              );
            },
          ),
        ),
        barrierDismissible: false,
      );
    } else if (permission ==
        LocationPermission.deniedForever) {
      userLocation.value =
      "Permission denied";
    } else {
      // Already allowed
      _getCurrentCity();
    }
  }

  // ========================================================================
  // HANDLE LOCATION PERMISSION
  // ========================================================================

  void _handlePermissionResult(
      LocationPermission permission,
      ) {
    if (permission ==
        LocationPermission.whileInUse ||
        permission ==
            LocationPermission.always) {
      _getCurrentCity();
    } else {
      userLocation.value =
      "Permission denied";
    }
  }

  // ========================================================================
  // GET CURRENT CITY
  // ========================================================================

  Future<void> _getCurrentCity() async {
    try {
      Position position =
      await Geolocator.getCurrentPosition(
        locationSettings:
        const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      // ================================================================
      // GET ADDRESS
      // ================================================================

      List<Placemark> placemarks =
      await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        userLocation.value =
        "${place.locality ?? ''}, "
            "${place.country ?? ''}";
      } else {
        userLocation.value =
        "Location detected";
      }
    } catch (e) {
      userLocation.value =
      "Unable to get location";
    }
  }

  // ========================================================================
  // DISPOSE
  // ========================================================================

  @override
  void onClose() {
    searchController.dispose();

    super.onClose();
  }
}