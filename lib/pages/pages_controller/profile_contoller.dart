import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manganjawa/services/auth_service.dart';

class ProfileController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final RxBool isEditing = false.obs;
  final TextEditingController nameController = TextEditingController();
  final RxString userEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final user = authService.getCurrentUser();
    nameController.text = user?.displayName ?? user?.email ?? '';
    userEmail.value = user?.email ?? '';
  }

  void toggleEditing() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value && nameController.text.isNotEmpty) {
      authService.updateUserName(nameController.text);
    }
  }

  void logout() {
    authService.signOut();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
