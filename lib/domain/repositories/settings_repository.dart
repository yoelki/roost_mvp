import 'package:roost_mvp/domain/entities/settings_entity.dart';

abstract class SettingsRepository {
  Future<SettingsEntity> getSettings();
  Future<void> updateSettings(SettingsEntity settings);
}
