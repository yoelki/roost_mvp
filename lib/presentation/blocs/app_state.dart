import 'package:equatable/equatable.dart';
import '../../domain/entities/app_entity.dart';

abstract class AppState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppInitial extends AppState {}

class AppLoading extends AppState {}

class AppLoaded extends AppState {
  final List<AppEntity> apps;

  AppLoaded(this.apps);

  @override
  List<Object?> get props => [apps];
}

class AppError extends AppState {
  final String message;

  AppError(this.message);

  @override
  List<Object?> get props => [message];
}
