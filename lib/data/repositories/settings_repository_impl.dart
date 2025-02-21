import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _prefs;

  static const _darkModeKey = 'darkMode';
  static const _notificationsKey = 'notifications';
  static const _languageKey = 'language';
  static const _autoUpdateKey = 'autoUpdate';

  SettingsRepositoryImpl(this._prefs);

  @override
  Future<SettingsEntity> getSettings() async {
    return SettingsEntity(
      darkMode: _prefs.getBool(_darkModeKey) ?? false,
      notificationsEnabled: _prefs.getBool(_notificationsKey) ?? true,
      language: _prefs.getString(_languageKey) ?? 'en',
      autoUpdate: _prefs.getBool(_autoUpdateKey) ?? true,
    );
  }

  @override
  Future<void> updateSettings(SettingsEntity settings) async {
    await _prefs.setBool(_darkModeKey, settings.darkMode);
    await _prefs.setBool(_notificationsKey, settings.notificationsEnabled);
    await _prefs.setString(_languageKey, settings.language);
    await _prefs.setBool(_autoUpdateKey, settings.autoUpdate);
  }
}
