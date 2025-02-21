import 'package:flutter/widgets.dart';

class DrawerMenuItem {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool selected;
  final String? route;

  const DrawerMenuItem({
    required this.title,
    required this.icon,
    this.onTap,
    this.selected = false,
    this.route,
  });
}
