import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manganjawa/auth/auth_widgets/mycolors.dart';
import 'package:manganjawa/pages/pages_controller/profile_contoller.dart';
import 'dart:io';

import 'package:manganjawa/routes/routes.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(context),
              const SizedBox(height: 40),
              _buildProfilePicture(),
              const SizedBox(height: 40),
              _buildNameCard(context),
              const SizedBox(height: 16),
              _buildEmailCard(context),
              const Spacer(),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Text(
        'Profile',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.textColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          final ImagePicker _picker = ImagePicker();
          final XFile? image =
              await _picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            controller.updateProfileImage(image.path);
          }
        },
        child: Obx(() => Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: controller.profileImagePath.isNotEmpty
                  ? ClipOval(
                      child: Image.file(
                        File(controller.profileImagePath.value),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 60,
                      color: AppColors.textColor,
                    ),
            )),
      ),
    );
  }

  Widget _buildNameCard(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.subText,
                    ),
              ),
              const SizedBox(height: 8),
              Obx(() => Row(
                    children: [
                      Expanded(
                        child: controller.isEditing.value
                            ? TextField(
                                controller: controller.nameController,
                                style:
                                    const TextStyle(color: AppColors.textColor),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              )
                            : Text(
                                controller.nameController.text,
                                style: const TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                      IconButton(
                        icon: Icon(
                          controller.isEditing.value ? Icons.check : Icons.edit,
                          color: AppColors.secondary,
                        ),
                        onPressed: controller.toggleUsernameEditing,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailCard(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.subText,
                    ),
              ),
              const SizedBox(height: 8),
              Obx(() => Text(
                    controller.userEmail.value,
                    style: const TextStyle(
                      color: AppColors.textColor,
                      fontSize: 16,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildButton(
          'History Checkout',
          Icons.history,
          Colors.orange,
          () => Get.toNamed(MyRoutes.orderHistoryPage),
        ),
        const SizedBox(height: 16),
        _buildButton(
          'Logout',
          Icons.logout,
          Colors.red,
          () => controller.logout(),
        ),
      ],
    );
  }

  Widget _buildButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textColor),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                color: AppColors.textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
