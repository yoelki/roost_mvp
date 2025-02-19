import '../entities/app_entity.dart';
import '../repositories/app_repository.dart';

class CreateApp {
  final AppRepository repository;

  CreateApp(this.repository);

  Future<void> call(AppEntity app) async {
    await repository.createApp(app);
  }
}
