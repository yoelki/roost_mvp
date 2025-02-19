import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roost_mvp/domain/entities/user_entity.dart';
import 'package:roost_mvp/presentation/blocs/auth/auth_bloc.dart';
import 'package:roost_mvp/presentation/blocs/auth/auth_state.dart';
import 'package:roost_mvp/presentation/screens/app_list_screen.dart';
import 'package:roost_mvp/presentation/screens/auth/login_screen.dart';
import 'package:roost_mvp/presentation/widgets/auth_guard.dart';
import 'package:roost_mvp/presentation/blocs/app_bloc.dart';
import 'package:roost_mvp/presentation/blocs/app_state.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

class MockAppBloc extends Mock implements AppBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockAppBloc mockAppBloc;
  late Widget authenticatedRoute;
  late Widget unauthenticatedRoute;
  late StreamController<AuthState> authStreamController;
  late StreamController<AppState> appStreamController;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockAppBloc = MockAppBloc();
    authenticatedRoute = const AppListScreen();
    unauthenticatedRoute = const LoginScreen();
    authStreamController = StreamController<AuthState>.broadcast();
    appStreamController = StreamController<AppState>.broadcast();

    // Mock the streams
    when(() => mockAuthBloc.stream)
        .thenAnswer((_) => authStreamController.stream);
    when(() => mockAppBloc.stream)
        .thenAnswer((_) => appStreamController.stream);
    when(() => mockAppBloc.state).thenReturn(AppInitial());
  });

  tearDown(() async {
    await authStreamController.close();
    await appStreamController.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          BlocProvider<AppBloc>.value(value: mockAppBloc),
        ],
        child: AuthGuard(
          authenticatedRoute: authenticatedRoute,
          unauthenticatedRoute: unauthenticatedRoute,
        ),
      ),
    );
  }

  group('AuthGuard', () {
    testWidgets('should show authenticated route when authenticated',
        (tester) async {
      final user = UserEntity(id: '1', email: 'test@test.com');
      when(() => mockAuthBloc.state).thenReturn(Authenticated(user));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(AppListScreen), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
    });

    testWidgets('should show unauthenticated route when not authenticated',
        (tester) async {
      when(() => mockAuthBloc.state).thenReturn(Unauthenticated());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(AppListScreen), findsNothing);
    });
  });
}
