import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onFacebookPressed;
  final VoidCallback onApplePressed;

  const SocialLoginButtons({
    super.key,
    required this.onGooglePressed,
    required this.onFacebookPressed,
    required this.onApplePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.g_mobiledata, color: Colors.white),
          onPressed: onGooglePressed,
        ),
        IconButton(
          icon: const Icon(Icons.facebook, color: Colors.white),
          onPressed: onFacebookPressed,
        ),
        IconButton(
          icon: const Icon(Icons.apple, color: Colors.white),
          onPressed: onApplePressed,
        ),
      ],
    );
  }
} 