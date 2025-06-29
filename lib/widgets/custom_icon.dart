import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;

  const CustomIcon({
    Key? key,
    required this.icon,
    this.size = 28.0,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: size, color: color);
  }
}
