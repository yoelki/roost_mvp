import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roost_mvp/presentation/models/drawer_menu_item.dart';

void main() {
  group('DrawerMenuItem', () {
    test('should create drawer menu item with required properties', () {
      final menuItem = DrawerMenuItem(
        title: 'Test Item',
        icon: Icons.home_outlined,
        onTap: () {},
      );
      expect(menuItem.title, 'Test Item');
      expect(menuItem.icon, Icons.home_outlined);
      expect(menuItem.selected, false);
    });

    test('should create drawer menu item with selected state', () {
      final menuItem = DrawerMenuItem(
        title: 'Test Item',
        icon: Icons.home_outlined,
        selected: true,
        onTap: () {},
      );

      expect(menuItem.selected, true);
    });
  });
}
