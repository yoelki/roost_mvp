import '../entities/app_entity.dart';
import '../repositories/app_repository.dart';

class GetApps {
  final AppRepository repository;

  GetApps(this.repository);

  Future<List<AppEntity>> call() async {
    return await repository.getApps();
  }
}
