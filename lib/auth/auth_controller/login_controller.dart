import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:manganjawa/routes/routes.dart';
import 'package:manganjawa/auth/auth_services/auth_service.dart';

class LoginController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthService authService = Get.put(AuthService());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    if (await authService.isLoggedIn()) {
      Get.offAllNamed(MyRoutes.bottomNavigation);
    }
  }

  Future<String?> getAdminEmail() async {
    try {
      final doc = await _firestore.collection('config').doc('admin').get();
      if (doc.exists) {
        return doc['admin_email'];
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch admin email: ${e.toString()}");
    }
    return null;
  }

  void login() async {
    final email = emailController.text;
    final password = passwordController.text;

    try {
      final user = await authService.logIn(email, password);
      if (user != null) {
        await authService.checkAdminStatus(email);
        final adminEmail = await getAdminEmail();
        if (email == adminEmail) {
          Get.offAllNamed(MyRoutes.bottomNavigation);
        } else {
          Get.offAllNamed(MyRoutes.bottomNavigation);
        }
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
        Get.offAllNamed(MyRoutes.bottomNavigation);
      } else {
        Get.snackbar("Error", "Login failed. Please try again.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
