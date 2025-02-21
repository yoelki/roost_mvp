import 'package:equatable/equatable.dart';

class SettingsEntity extends Equatable {
  final bool darkMode;
  final bool notificationsEnabled;
  final String language;
  final bool autoUpdate;

  const SettingsEntity({
    required this.darkMode,
    required this.notificationsEnabled,
    required this.language,
    required this.autoUpdate,
  });

  @override
  List<Object?> get props => [
        darkMode,
        notificationsEnabled,
        language,
        autoUpdate,
      ];

  SettingsEntity copyWith({
    bool? darkMode,
    bool? notificationsEnabled,
    String? language,
    bool? autoUpdate,
  }) {
    return SettingsEntity(
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      autoUpdate: autoUpdate ?? this.autoUpdate,
    );
  }
}
