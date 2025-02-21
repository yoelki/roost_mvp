import 'package:roost_mvp/domain/entities/settings_entity.dart';
import 'package:roost_mvp/domain/repositories/settings_repository.dart';

class UpdateSettings {
  final SettingsRepository repository;

  UpdateSettings(this.repository);

  Future<void> call(SettingsEntity settings) =>
      repository.updateSettings(settings);
}
