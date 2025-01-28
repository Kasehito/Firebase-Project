import 'package:flutter/material.dart';

class HomeContainer extends StatelessWidget {
  final Widget child;

  const HomeContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40),
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Color(0xFF393939)),
      child: child,
    );
  }
}
