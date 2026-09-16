import 'package:get/get.dart';
import 'package:mye_commerce/presentation/auth/ui/login/screen/login_screen.dart';
import 'package:mye_commerce/presentation/auth/ui/register/screen/register_screen.dart';
import 'package:mye_commerce/presentation/intro/ui/screen/intro_screen.dart';
// Make sure to import your LoginScreen here
// import 'package:mye_commerce/presentation/login/ui/screen/login_screen.dart';

import 'all_binding.dart';

class AllRoute {
  static const String intro = '/intro';
  static const String login = '/login';
  static const String register = '/register';

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
  ];
}