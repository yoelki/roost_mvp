import '../entities/app_entity.dart';

abstract class AppRepository {
  Future<List<AppEntity>> getApps();
  Future<void> createApp(AppEntity app);
}
