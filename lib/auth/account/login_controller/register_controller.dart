import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:manganjawa/routes/routes.dart';
import 'package:manganjawa/services/auth_service.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPwController = TextEditingController();

  AuthService authService = Get.put(AuthService());

  void register() async {
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPw = confirmPwController.text;

    if (password != confirmPw) {
      Get.snackbar("Error", "Password and Confirm Password must be the same");
      return;
    }

    try {
      final user = await authService.signUp(email, password);
      if (user != null) {
        Get.offAllNamed(MyRoutes.login);
      } else {
        Get.snackbar("Error", "Registration failed. Please try again.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
