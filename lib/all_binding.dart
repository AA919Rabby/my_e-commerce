
import 'package:get/get.dart';
import 'package:mye_commerce/presentation/auth/controller/auth_controller.dart';
import 'package:mye_commerce/presentation/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:mye_commerce/presentation/home/controller/home_controller.dart';
import 'package:mye_commerce/presentation/intro/controller/intro_controller.dart';
import 'package:mye_commerce/presentation/profile/controller/profile_controller.dart';

class AllBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => IntroController(), fenix: true);
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(()=>BottomNavController(), fenix: true);
    Get.lazyPut(()=>HomeController(), fenix: true);
    Get.lazyPut(()=>ProfileController(), fenix: true);

  }
}