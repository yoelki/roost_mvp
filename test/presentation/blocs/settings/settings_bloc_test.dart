import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roost_mvp/domain/entities/settings_entity.dart';
import 'package:roost_mvp/domain/usecases/settings/get_settings.dart';
import 'package:roost_mvp/domain/usecases/settings/update_settings.dart';
import 'package:roost_mvp/presentation/blocs/settings/settings_bloc.dart';
import 'package:roost_mvp/presentation/blocs/settings/settings_event.dart';
import 'package:roost_mvp/presentation/blocs/settings/settings_state.dart';

class MockGetSettings extends Mock implements GetSettings {}

class MockUpdateSettings extends Mock implements UpdateSettings {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const SettingsEntity(
        darkMode: false,
        notificationsEnabled: true,
        language: 'en',
        autoUpdate: true,
      ),
    );
  });

  late SettingsBloc bloc;
  late MockGetSettings mockGetSettings;
  late MockUpdateSettings mockUpdateSettings;
  late SettingsEntity defaultSettings;

  setUp(() {
    mockGetSettings = MockGetSettings();
    mockUpdateSettings = MockUpdateSettings();
    defaultSettings = const SettingsEntity(
      darkMode: false,
      notificationsEnabled: true,
      language: 'en',
      autoUpdate: true,
    );

    when(() => mockGetSettings.call()).thenAnswer((_) async => defaultSettings);
    when(() => mockUpdateSettings.call(any())).thenAnswer((_) async {});

    bloc = SettingsBloc(
      getSettings: mockGetSettings,
      updateSettings: mockUpdateSettings,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be SettingsInitial', () {
    expect(bloc.state, isA<SettingsInitial>());
  });

  group('LoadSettings', () {
    test('should emit SettingsLoaded with settings', () async {
      // Act
      bloc.add(LoadSettings());

      // Assert
      await expectLater(
        bloc.stream,
        emits(SettingsLoaded(defaultSettings)),
      );
      verify(() => mockGetSettings.call()).called(1);
    });
  });

  group('UpdateDarkMode', () {
    test('should update dark mode setting', () async {
      // Arrange
      bloc.add(LoadSettings());
      await Future.delayed(Duration.zero);

      // Act
      bloc.add(UpdateDarkMode(true));

      // Assert
      await expectLater(
        bloc.stream,
        emits(
          SettingsLoaded(
            defaultSettings.copyWith(darkMode: true),
          ),
        ),
      );
      verify(() => mockUpdateSettings.call(any())).called(1);
    });
  });

  // Similar tests for other settings...
}
