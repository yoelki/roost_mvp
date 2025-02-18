import '../../domain/entities/app_entity.dart';

abstract class AppState {}

class AppInitial extends AppState {}

class AppLoading extends AppState {}

class AppLoaded extends AppState {
  final List<AppEntity> apps;
  AppLoaded(this.apps);
}

class AppError extends AppState {
  final String message;
  AppError(this.message);
}
