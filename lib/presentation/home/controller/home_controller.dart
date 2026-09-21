import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../global/custom_button.dart';
import '../../../../global/custom_confirm_dialog.dart';


class HomeController extends GetxController {
  // Dummy User Name
  final userName = "Alex Freeman".obs;

  // Location display text
  final userLocation = "Fetching location...".obs;

  // Search controller
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Prompt for location when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAndRequestLocation();
    });
  }

  /// Check GPS and Permission, then fetch location
  Future<void> checkAndRequestLocation() async {
    // 1. Check if GPS / Location Service is turned on
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      // Show "Turn On Location" popup if GPS is OFF
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

    // 2. If GPS is ON, check permissions
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // Show "Allow Location" popup
      Get.dialog(
        CustomConfirmDialog(
          icon: Icons.location_on_outlined,
          iconColor: AppColor.primary,
          title: "Allow location access to find products near you",
          child: CustomButton(
            text: "Allow Location",
            backgroundColor: AppColor.drawerGradient1,
            textColor: Colors.white,
            onPressed: () async {
              Get.back();
              permission = await Geolocator.requestPermission();
              _handlePermissionResult(permission);
            },
          ),
        ),
        barrierDismissible: false,
      );
    } else if (permission == LocationPermission.deniedForever) {
      userLocation.value = "Permission denied";
    } else {
      // Already allowed
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

      // Fetch address from coordinates
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
}