import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;

  const CategoryCard({
    Key? key,
    required this.color,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 64,
        padding: const EdgeInsets.all(16),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Center(
          child: Icon(icon, size: 32),
        ),
      ),
    );
  }
}
