import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:manganjawa/Pages/auth/services/auth_service.dart';
import 'package:manganjawa/routes/routes.dart';

class LoginController extends GetxController {
  AuthService authService = Get.put(AuthService());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    final email = emailController.text;
    final password = passwordController.text;

    try {
      final user = await authService.logIn(email, password);
      if (user != null) {
        Get.offAllNamed(MyRoutes.home);
      } else {
        Get.snackbar("Error", "Login failed. Please check your credentials.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void signInWithGoogle() async {
    try {
      final user = await authService.signInWithGoogle();
      if (user != null) {
        Get.offAllNamed(MyRoutes.home);
      } else {
        Get.snackbar("Error", "Login failed. Please try again.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
