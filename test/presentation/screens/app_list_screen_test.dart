import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roost_mvp/domain/entities/app_entity.dart';
import 'package:roost_mvp/presentation/blocs/app_bloc.dart';
import 'package:roost_mvp/presentation/blocs/app_event.dart';
import 'package:roost_mvp/presentation/blocs/app_state.dart';
import 'package:roost_mvp/presentation/blocs/auth/auth_bloc.dart';
import 'package:roost_mvp/presentation/blocs/auth/auth_event.dart';
import 'package:roost_mvp/presentation/screens/app_list_screen.dart';
import '../../helpers/auth_protected_screen_base.dart';

class MockAppBloc extends Mock implements AppBloc {}

class MockAuthBloc extends Mock implements AuthBloc {}

class AppListScreenTest extends AuthProtectedScreenBase {
  @override
  void setUp() {
    super.setUp();
    registerFallbackValue(FetchApps());
    registerFallbackValue(SignOutRequested());
  }

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>.value(value: mockAppBloc),
        BlocProvider<AuthBloc>.value(value: mockAuthBloc),
      ],
      child: MaterialApp(
        home: const AppListScreen(),
      ),
    );
  }
}

void main() {
  late AppListScreenTest tester;

  setUp(() {
    tester = AppListScreenTest();
    tester.setUp();
  });

  tearDown(() async {
    await tester.tearDown();
  });

  group('AppListScreen', () {
    testWidgets('should fetch apps on init', (widgetTester) async {
      await widgetTester.pumpWidget(tester.createWidgetUnderTest());
      await widgetTester.pump();

      verify(() => tester.mockAppBloc.add(any<FetchApps>())).called(1);
    });

    testWidgets('should show loading indicator when loading',
        (widgetTester) async {
      when(() => tester.mockAppBloc.state).thenReturn(AppLoading());

      await widgetTester.pumpWidget(tester.createWidgetUnderTest());
      tester.appStreamController.add(AppLoading());
      await widgetTester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error message when error occurs',
        (widgetTester) async {
      const errorMessage = 'Error message';
      when(() => tester.mockAppBloc.state).thenReturn(AppError(errorMessage));

      await widgetTester.pumpWidget(tester.createWidgetUnderTest());
      tester.appStreamController.add(AppError(errorMessage));
      await widgetTester.pump();

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should show apps list when loaded', (widgetTester) async {
      final apps = [
        AppEntity(id: '1', name: 'Test App 1', platform: 'iOS', version: '1.0'),
        AppEntity(
            id: '2', name: 'Test App 2', platform: 'Android', version: '1.0'),
      ];

      when(() => tester.mockAppBloc.state).thenReturn(AppLoaded(apps));

      await widgetTester.pumpWidget(tester.createWidgetUnderTest());
      tester.appStreamController.add(AppLoaded(apps));
      await widgetTester.pump();

      expect(find.text('Test App 1'), findsOneWidget);
      expect(find.text('Test App 2'), findsOneWidget);
      expect(find.text('Platform: iOS'), findsOneWidget);
      expect(find.text('Platform: Android'), findsOneWidget);
    });

    testWidgets('should trigger sign out when logout button is pressed',
        (widgetTester) async {
      await widgetTester.pumpWidget(tester.createWidgetUnderTest());

      // Open the drawer first
      await widgetTester.tap(find.byTooltip(
          'Open navigation menu')); // More specific finder for drawer button
      await widgetTester.pumpAndSettle();

      // Find the logout button specifically in the drawer
      final logoutButton = find.widgetWithIcon(ListTile, Icons.logout);
      await widgetTester.tap(logoutButton);
      await widgetTester.pump();

      verify(() => tester.mockAuthBloc.add(SignOutRequested())).called(1);
    });
  });
}
