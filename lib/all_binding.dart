
import 'package:get/get.dart';
import 'package:mye_commerce/presentation/auth/controller/auth_controller.dart';
import 'package:mye_commerce/presentation/intro/controller/intro_controller.dart';

class AllBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => IntroController(), fenix: true);
    Get.lazyPut(() => AuthController(), fenix: true);



  }
}