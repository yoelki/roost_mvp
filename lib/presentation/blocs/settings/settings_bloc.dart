import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/settings/get_settings.dart';
import '../../../domain/usecases/settings/update_settings.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings getSettings;
  final UpdateSettings updateSettings;

  SettingsBloc({
    required this.getSettings,
    required this.updateSettings,
  }) : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateDarkMode>(_onUpdateDarkMode);
    on<UpdateNotifications>(_onUpdateNotifications);
    on<UpdateLanguage>(_onUpdateLanguage);
    on<UpdateAutoUpdate>(_onUpdateAutoUpdate);
  }

  Future<void> _onLoadSettings(
      LoadSettings event, Emitter<SettingsState> emit) async {
    final settings = await getSettings();
    emit(SettingsLoaded(settings));
  }

  Future<void> _onUpdateDarkMode(
      UpdateDarkMode event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final newSettings = currentSettings.copyWith(darkMode: event.enabled);
      await updateSettings(newSettings);
      emit(SettingsLoaded(newSettings));
    }
  }

  Future<void> _onUpdateNotifications(
      UpdateNotifications event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final newSettings =
          currentSettings.copyWith(notificationsEnabled: event.enabled);
      await updateSettings(newSettings);
      emit(SettingsLoaded(newSettings));
    }
  }

  Future<void> _onUpdateLanguage(
      UpdateLanguage event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final newSettings = currentSettings.copyWith(language: event.language);
      await updateSettings(newSettings);
      emit(SettingsLoaded(newSettings));
    }
  }

  Future<void> _onUpdateAutoUpdate(
      UpdateAutoUpdate event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final newSettings = currentSettings.copyWith(autoUpdate: event.enabled);
      await updateSettings(newSettings);
      emit(SettingsLoaded(newSettings));
    }
  }
}
