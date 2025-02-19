import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/drawer_menu_item.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DrawerMenuItem> menuItems = [
      DrawerMenuItem(
        title: 'Apps',
        icon: Icons.apps,
        selected: true,
        onTap: () => Navigator.pop(context),
      ),
      DrawerMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        onTap: () {
          Navigator.pop(context);
          // TODO: Navigate to settings screen
        },
      ),
      DrawerMenuItem(
        title: 'Help & Feedback',
        icon: Icons.help,
        onTap: () {
          Navigator.pop(context);
          // TODO: Navigate to help screen
        },
      ),
      DrawerMenuItem(
        title: 'Sign Out',
        icon: Icons.logout,
        onTap: () {
          Navigator.pop(context);
          context.read<AuthBloc>().add(SignOutRequested());
        },
      ),
    ];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(context),
          ...menuItems.map(_buildMenuItem).toList(),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 35,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Roost MVP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(DrawerMenuItem item) {
    if (item.title == 'Help & Feedback') {
      return Column(
        children: [
          const Divider(),
          ListTile(
            leading: Icon(item.icon),
            title: Text(item.title),
            selected: item.selected,
            onTap: item.onTap,
          ),
        ],
      );
    }
    return ListTile(
      leading: Icon(item.icon),
      title: Text(item.title),
      selected: item.selected,
      onTap: item.onTap,
    );
  }
}
