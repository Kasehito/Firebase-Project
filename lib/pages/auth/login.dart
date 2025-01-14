import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:manganjawa/controller/login_controller.dart';
import 'package:manganjawa/routes/routes.dart';

class LoginPage extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Column(
            children: [
              //logo
              Icon(
                Icons.food_bank,
                size: 100,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              //title
              Text(
                'Mangan Jawa',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              //email field
              TextField(
                controller: loginController.emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ),
              //password field
              TextField(
                controller: loginController.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              //login button
              ElevatedButton(
                onPressed: loginController.login,
                child: Text("Login"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              //signup button
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                onPressed: () {
                  Get.toNamed(MyRoutes.signup);
                },
                child: Text('Create Account'),
              ),
              IconButton(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedGoogle,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                onPressed: () async {
                  loginController.signInWithGoogle();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
