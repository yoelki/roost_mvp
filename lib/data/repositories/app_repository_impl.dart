import '../../domain/entities/app_entity.dart';
import '../../domain/repositories/app_repository.dart';
import '../datasources/firestore_data_source.dart';
import '../models/app_model.dart';

class AppRepositoryImpl implements AppRepository {
  final FirestoreDataSource firestoreDataSource;

  AppRepositoryImpl(this.firestoreDataSource);

  @override
  Future<List<AppModel>> getApps() async {
    return await firestoreDataSource.getApps();
  }

  @override
  Future<void> createApp(AppEntity app) async {
    final appModel = AppModel(
      id: app.id,
      name: app.name,
      platform: app.platform,
      version: app.version,
    );
    await firestoreDataSource.createApp(appModel);
  }
}
