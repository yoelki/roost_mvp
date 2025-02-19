import 'package:flutter/widgets.dart';

class DrawerMenuItem {
  final String title;
  final IconData icon;
  final bool selected;
  final Function() onTap;

  const DrawerMenuItem({
    required this.title,
    required this.icon,
    this.selected = false,
    required this.onTap,
  });
}
