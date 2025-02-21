import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/settings/settings_bloc.dart';
import '../blocs/settings/settings_event.dart';
import '../blocs/settings/settings_state.dart';
import '../widgets/app_drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      drawer: const AppDrawer(),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is! SettingsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = state.settings;
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Toggle dark theme'),
                value: settings.darkMode,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(UpdateDarkMode(value));
                },
              ),
              SwitchListTile(
                title: const Text('Notifications'),
                subtitle: const Text('Enable push notifications'),
                value: settings.notificationsEnabled,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(UpdateNotifications(value));
                },
              ),
              ListTile(
                title: const Text('Language'),
                subtitle: Text(settings.language),
                trailing: DropdownButton<String>(
                  value: settings.language,
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'es', child: Text('Spanish')),
                    DropdownMenuItem(value: 'fr', child: Text('French')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context.read<SettingsBloc>().add(UpdateLanguage(value));
                    }
                  },
                ),
              ),
              SwitchListTile(
                title: const Text('Auto Update'),
                subtitle: const Text('Keep apps up to date'),
                value: settings.autoUpdate,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(UpdateAutoUpdate(value));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
