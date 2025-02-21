abstract class SettingsEvent {}

class LoadSettings extends SettingsEvent {}

class UpdateDarkMode extends SettingsEvent {
  final bool enabled;
  UpdateDarkMode(this.enabled);
}

class UpdateNotifications extends SettingsEvent {
  final bool enabled;
  UpdateNotifications(this.enabled);
}

class UpdateLanguage extends SettingsEvent {
  final String language;
  UpdateLanguage(this.language);
}

class UpdateAutoUpdate extends SettingsEvent {
  final bool enabled;
  UpdateAutoUpdate(this.enabled);
}
