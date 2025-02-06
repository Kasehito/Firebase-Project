import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manganjawa/auth/auth_services/auth_service.dart';

class ProfileController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final RxBool isEditing = false.obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController profileImageController = TextEditingController();
  final RxString userEmail = ''.obs;
  var profileImagePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final user = authService.getCurrentUser();
    nameController.text = user?.displayName ?? user?.email ?? '';
    profileImageController.text = user?.photoURL ?? '';
    profileImagePath.value = user?.photoURL ?? '';
    userEmail.value = user?.email ?? '';
  }

  void toggleUsernameEditing() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value && nameController.text.isNotEmpty) {
      authService.updateUserName(nameController.text);
    }
  }

  void updateProfileImage(String imagePath) {
    if (imagePath.isNotEmpty) {
      profileImagePath.value = imagePath;

      authService.updateProfilePicture(imagePath);
    }
  }

  void logout() {
    authService.signOut();
  }

  void removeProfileImage() {
    profileImagePath.value = '';
    authService.updateProfilePicture('');
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
