import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roost_mvp/domain/entities/settings_entity.dart';
import 'package:roost_mvp/presentation/blocs/auth/auth_state.dart';
import 'package:roost_mvp/presentation/blocs/settings/settings_bloc.dart';
import 'package:roost_mvp/presentation/blocs/settings/settings_event.dart';
import 'package:roost_mvp/presentation/blocs/settings/settings_state.dart';
import 'package:roost_mvp/presentation/screens/settings_screen.dart';
import 'package:roost_mvp/presentation/blocs/auth/auth_bloc.dart';
import 'package:roost_mvp/domain/entities/user_entity.dart';

class MockSettingsBloc extends Mock implements SettingsBloc {}

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue(UpdateDarkMode(true));
    registerFallbackValue(UpdateLanguage('en'));
    registerFallbackValue(UpdateNotifications(true));
    registerFallbackValue(UpdateAutoUpdate(true));
  });

  late MockSettingsBloc mockSettingsBloc;
  late MockAuthBloc mockAuthBloc;
  late SettingsEntity defaultSettings;

  setUp(() {
    mockSettingsBloc = MockSettingsBloc();
    mockAuthBloc = MockAuthBloc();
    defaultSettings = const SettingsEntity(
      darkMode: false,
      notificationsEnabled: true,
      language: 'en',
      autoUpdate: true,
    );

    // Mock settings bloc
    when(() => mockSettingsBloc.state)
        .thenReturn(SettingsLoaded(defaultSettings));
    when(() => mockSettingsBloc.stream)
        .thenAnswer((_) => Stream.value(SettingsLoaded(defaultSettings)));

    // Mock auth bloc for drawer
    when(() => mockAuthBloc.state)
        .thenReturn(Authenticated(UserEntity(id: '1', email: 'test@test.com')));
    when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(
        Authenticated(UserEntity(id: '1', email: 'test@test.com'))));
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
        ],
        child: const SettingsScreen(),
      ),
    );
  }

  group('SettingsScreen', () {
    testWidgets('should show loading indicator when not loaded',
        (tester) async {
      when(() => mockSettingsBloc.state).thenReturn(SettingsInitial());
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show all settings when loaded', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Auto Update'), findsOneWidget);
    });

    testWidgets('should toggle dark mode', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the specific SwitchListTile for dark mode
      final switchTile = find.ancestor(
        of: find.text('Dark Mode'),
        matching: find.byType(SwitchListTile),
      );

      // Find and tap the switch within that tile
      final switchFinder = find.descendant(
        of: switchTile,
        matching: find.byType(Switch),
      );

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      verify(() => mockSettingsBloc.add(any(that: isA<UpdateDarkMode>())))
          .called(1);
    });

    testWidgets('should change language', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find and open the language dropdown
      final languageTile = find.ancestor(
        of: find.text('Language'),
        matching: find.byType(ListTile),
      );
      final dropdown = find.descendant(
        of: languageTile,
        matching: find.byType(DropdownButton<String>),
      );
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      // Select Spanish option
      await tester.tap(find.text('Spanish').last);
      await tester.pumpAndSettle();

      verify(() => mockSettingsBloc.add(any(that: isA<UpdateLanguage>())))
          .called(1);
    });
  });
}
