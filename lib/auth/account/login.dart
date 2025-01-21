import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manganjawa/routes/routes.dart';
import 'components/custom_text_field.dart';
import 'components/custom_button.dart';
import 'components/social_login_buttons.dart';
import 'components/divider_or.dart';
import 'controller/login_controller.dart';

class LoginPage extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFF393939),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/login.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Image.asset(
                            'images/loginImage.png',
                            width: double.infinity,
                            height: 330,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Column(
                              children: [
                                const Text(
                                  'Welcome Eaters',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 33,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'please login to your account',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.50,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                CustomTextField(
                                  controller: loginController.emailController,
                                  hintText: 'Enter email or phone',
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  controller:
                                      loginController.passwordController,
                                  hintText: 'Password',
                                  obscureText: true,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: Color(0xFFF79515),
                                        fontSize: 8.25,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                CustomButton(
                                  onPressed: loginController.login,
                                  text: 'Log In',
                                ),
                                const SizedBox(height: 20),
                                const DividerOr(),
                                const SizedBox(height: 20),
                                SocialLoginButtons(
                                  onGooglePressed: () =>
                                      loginController.signInWithGoogle(),
                                  onFacebookPressed: () {},
                                  onApplePressed: () {},
                                ),
                                const SizedBox(
                                    height: 20), 
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Don't have an Account? ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => Get.toNamed(MyRoutes.signup),
                                      child: const Text(
                                        'Create Account',
                                        style: TextStyle(
                                          color: Color(0xFFF79515),
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
