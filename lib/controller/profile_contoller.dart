import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manganjawa/auth/account/services/auth_service.dart';

class ProfileController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final RxBool isPasswordVisible = false.obs;
  final RxBool isEditing = false.obs;
  final TextEditingController nameController = TextEditingController();
  
  @override
  void onInit() {
    super.onInit();
    // Initialize name with email (you'll need to get this from AuthService)
    final user = authService.getCurrentUser();
    nameController.text = user?.displayName ?? user?.email ?? '';
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleEditing() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value && nameController.text.isNotEmpty) {
      // Save the name changes
      authService.updateUserName(nameController.text);
    }
  }

  void logout() {
    authService.signOut();
  }
}