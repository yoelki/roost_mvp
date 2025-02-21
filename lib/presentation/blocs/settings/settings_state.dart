import 'package:equatable/equatable.dart';
import 'package:roost_mvp/domain/entities/settings_entity.dart';

abstract class SettingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final SettingsEntity settings;

  SettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}
