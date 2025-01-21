import 'package:flutter/material.dart';

class HomeContainer extends StatelessWidget {
  final Widget child;

  const HomeContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      height: 812,
      padding: const EdgeInsets.only(top: 60, bottom: 43),
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Color(0xFF393939)),
      child: child,
    );
  }
}
