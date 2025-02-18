import 'package:roost_mvp/domain/entities/app_entity.dart';
import 'package:roost_mvp/domain/repositories/app_repository.dart';

class GetApps {
  final AppRepository repository;

  GetApps(this.repository);

  Future<List<AppEntity>> call() async {
    return await repository.getApps();
  }
}
