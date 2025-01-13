import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final bool obsecureText;
  final TextEditingController controller;

  const MyTextfield({
    super.key,
    required this.hintText,
    required this.obsecureText,
    required this.controller,
    
    });

  @override
  Widget build(BuildContext context) {
    return const TextField();
  }
}
