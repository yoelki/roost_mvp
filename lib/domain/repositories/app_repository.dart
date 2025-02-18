import 'package:roost_mvp/domain/entities/app_entity.dart';

abstract class AppRepository {
  Future<List<AppEntity>> getApps();
  Future<void> createApp(AppEntity app);
}
