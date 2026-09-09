import 'package:get/get.dart';
import 'package:mye_commerce/presentation/intro/ui/screen/intro_screen.dart';

import 'all_binding.dart';

class AllRoute {
  static const String intro = '/intro';

  static final List<GetPage> routes = [
    GetPage(
      name: intro,
      page: () => IntroScreen(),
      binding: AllBinding(),
    ),
  ];
}