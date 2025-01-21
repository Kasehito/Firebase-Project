import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:manganjawa/auth/account/login_components/mycolors.dart';

import 'package:manganjawa/pages/pages_controller/profile_contoller.dart';

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
              _buildLogoutButton(),
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
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.orange, width: 2),
        ),
        child: const Icon(
          Icons.person,
          size: 60,
          color: AppColors.textColor,
        ),
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
                                style: const TextStyle(color: AppColors.textColor),
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
                        onPressed: controller.toggleEditing,
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

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => controller.logout(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Logout',
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}