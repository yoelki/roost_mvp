import '../../domain/entities/app_entity.dart';
import '../../domain/repositories/app_repository.dart';
import '../datasources/remote_data_source.dart';
import '../models/app_model.dart';

class AppRepositoryImpl implements AppRepository {
  final RemoteDataSource remoteDataSource;

  AppRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<AppModel>> getApps() async {
    return await remoteDataSource.getApps();
  }

  @override
  Future<void> createApp(AppEntity app) async {
    // API call to create app (omitted for brevity)
  }
}
