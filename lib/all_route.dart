import 'package:get/get.dart';
import 'package:mye_commerce/presentation/auth/ui/login/screen/enter_new_password_screen.dart';
import 'package:mye_commerce/presentation/auth/ui/login/screen/enter_otp_screen.dart';
import 'package:mye_commerce/presentation/auth/ui/login/screen/forget_password_screen.dart';
import 'package:mye_commerce/presentation/auth/ui/login/screen/login_screen.dart';
import 'package:mye_commerce/presentation/auth/ui/register/screen/register_screen.dart';
import 'package:mye_commerce/presentation/bottom_nav/ui/screen/bottom_nav_screen.dart';
import 'package:mye_commerce/presentation/cart/ui/widget/payment_web_view.dart'; // <-- ADD THIS IMPORT
import 'package:mye_commerce/presentation/cart/ui/widget/push_services.dart';
import 'package:mye_commerce/presentation/home/data/product_details_model.dart';
import 'package:mye_commerce/presentation/home/ui/screen/home_product_details_screen.dart';
import 'package:mye_commerce/presentation/home/ui/widget/product_all_screen.dart';
import 'package:mye_commerce/presentation/intro/ui/screen/intro_screen.dart';
import 'package:mye_commerce/presentation/notificatioon/ui/screen/notification_screen.dart';
import 'package:mye_commerce/presentation/profile/ui/screen/profile_screen.dart';
import 'package:mye_commerce/presentation/profile/ui/screen/update_profile_screen.dart';

import 'all_binding.dart';

class AllRoute {
  static const String intro = '/intro';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetPassword = '/forget-password';
  static const String forgetPasswordEnterOtp= '/forget-password-enter-otp';
  static const String enterNewPassword= '/enter-new-password';
  static const String bottomNav= '/bottom-nav';
  static const String productDetails= '/productDetails';
  static const String myProfile= '/myProfile';
  static const String updateProfile= '/updateProfile';
  static const String notification= '/notification';
  static const String pushServices= '/pushServices';
  static const String paymentWebView = '/paymentWebView'; // <-- ADD THIS ROUTE STRING
  static const String viewAll = '/viewAll'; // <-- ADD THIS ROUTE STRING


  static final List<GetPage> routes = [
    GetPage(
      name: intro,
      page: () => const IntroScreen(),
      binding: AllBinding(),
    ),
    GetPage(
      name: login,
      page: () => LoginScreen(),
      binding: AllBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: register,
      page: () => RegisterScreen(),
      binding: AllBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: forgetPassword,
      page: () => ForgetPasswordScreen(),
      binding: AllBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: forgetPasswordEnterOtp,
      page: () => EnterOtpScreen(),
      binding: AllBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: enterNewPassword,
      page: () => EnterNewPasswordScreen(),
      binding: AllBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: bottomNav,
      page: () => BottomNavScreen(),
      binding: AllBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: productDetails,
      page: () => HomeProductDetailsScreen(),
      binding: AllBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: updateProfile,
      page: () => UpdateProfileScreen(),
      binding: AllBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: notification,
      page: () => NotificationScreen(),
      binding: AllBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: pushServices,
      page: () => PushServices(),
      binding: AllBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    // <-- ADD THIS GETPAGE ROUTE
    GetPage(
      name: paymentWebView,
      page: () => PaymentWebView(url: Get.arguments.toString()), // Receives URL from arguments
      binding: AllBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: viewAll,
      page: () =>ProductAllScreen(), // Receives URL from arguments
      binding: AllBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: myProfile,
      page: () =>ProfileScreen(), // Receives URL from arguments
      binding: AllBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 600),
    ),
  ];
}