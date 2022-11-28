import 'package:flutter/material.dart';
import '/utils/constants.dart';

class BottomNavigationItem extends StatelessWidget {
  final Icon icon;
  final double iconSize;
  final Function? onPressed;
  Color? color;

  BottomNavigationItem({
    required this.icon,
    required this.iconSize,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.all(0),
        iconSize: iconSize,
        color: Colors.redAccent,
        onPressed: () => onPressed!(),
    icon: icon);
  }
}