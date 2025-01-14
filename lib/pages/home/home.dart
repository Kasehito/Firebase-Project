import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manganjawa/Pages/auth/services/auth_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  AuthService authService = Get.put(AuthService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mangan Jawa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Mangan Jawa!'),
          ],
        ),
      ),
    );
  }
}
