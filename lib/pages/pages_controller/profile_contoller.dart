import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manganjawa/auth/auth_services/auth_service.dart';
import 'package:manganjawa/pages/widget/logout_confirmation.dart';

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
      authService.updateProfilePicture(imagePath);
      profileImagePath.value = imagePath;
    }
  }

  void logout() async {
    final bool? confirmed = await LogoutConfirmation.show(Get.context!);
    if (confirmed == true) {
      authService.signOut();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
