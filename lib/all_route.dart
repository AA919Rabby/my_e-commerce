import 'package:get/get.dart';
import 'package:mye_commerce/presentation/auth/ui/login/screen/enter_new_password_screen.dart';
import 'package:mye_commerce/presentation/auth/ui/login/screen/enter_otp_screen.dart';
import 'package:mye_commerce/presentation/auth/ui/login/screen/forget_password_screen.dart';
import 'package:mye_commerce/presentation/auth/ui/login/screen/login_screen.dart';
import 'package:mye_commerce/presentation/auth/ui/register/screen/register_screen.dart';
import 'package:mye_commerce/presentation/bottom_nav/ui/screen/bottom_nav_screen.dart';
import 'package:mye_commerce/presentation/home/data/product_details_model.dart';
import 'package:mye_commerce/presentation/home/ui/screen/home_product_details_screen.dart';
import 'package:mye_commerce/presentation/intro/ui/screen/intro_screen.dart';
import 'package:mye_commerce/presentation/profile/ui/screen/update_profile_screen.dart';
// Make sure to import your LoginScreen here
// import 'package:mye_commerce/presentation/login/ui/screen/login_screen.dart';

import 'all_binding.dart';

class AllRoute {
  static const String intro = '/intro';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetPassword = '/forget-password';
  static const String  forgetPasswordEnterOtp= '/forget-password-enter-otp';
  static const String  enterNewPassword= '/enter-new-password';
  static const String  bottomNav= '/bottom-nav';
  static const String  productDetails= '/productDetails';
  static const String  updateProfile= '/updateProfile';


  static final List<GetPage> routes = [
    GetPage(
      name: intro,
      page: () => const IntroScreen(),
      binding: AllBinding(),
    ),
    // ADDED login route page
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


  ];
}