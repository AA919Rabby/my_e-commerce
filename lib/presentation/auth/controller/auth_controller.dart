import 'package:get/get.dart';

class AuthController extends GetxController {
  // Separate variable for Login Password
  var isLoginPasswordObscured = true.obs;

  // Separate variable for Register Password
  var isRegisterPasswordObscured = true.obs;

  // Toggle function for Login
  void toggleLoginPasswordVisibility() {
    isLoginPasswordObscured.value = !isLoginPasswordObscured.value;
  }

  // Toggle function for Register
  void toggleRegisterPasswordVisibility() {
    isRegisterPasswordObscured.value = !isRegisterPasswordObscured.value;
  }

// Add your TextControllers here as well if you haven't already
// final emailController = TextEditingController();
// final passwordController = TextEditingController();
// final firstNameController = TextEditingController();
// final lastNameController = TextEditingController();
}