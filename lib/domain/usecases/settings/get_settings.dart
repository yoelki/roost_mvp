import 'package:roost_mvp/domain/entities/settings_entity.dart';
import 'package:roost_mvp/domain/repositories/settings_repository.dart';

class GetSettings {
  final SettingsRepository repository;

  GetSettings(this.repository);

  Future<SettingsEntity> call() => repository.getSettings();
}
