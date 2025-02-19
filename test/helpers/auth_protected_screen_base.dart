import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roost_mvp/domain/entities/user_entity.dart';
import 'package:roost_mvp/presentation/blocs/app_bloc.dart';
import 'package:roost_mvp/presentation/blocs/app_state.dart';
import 'package:roost_mvp/presentation/blocs/auth/auth_bloc.dart';
import 'package:roost_mvp/presentation/blocs/auth/auth_state.dart';
import 'auth_screen_test_helper.dart';

class MockAppBloc extends Mock implements AppBloc {}

class MockAuthBloc extends Mock implements AuthBloc {}

abstract class AuthProtectedScreenBase {
  late MockAppBloc mockAppBloc;
  late MockAuthBloc mockAuthBloc;
  late StreamController<AppState> appStreamController;
  late StreamController<AuthState> authStreamController;
  final user = UserEntity(id: '1', email: 'test@test.com');

  setUp() {
    mockAppBloc = MockAppBloc();
    mockAuthBloc = MockAuthBloc();
    appStreamController = StreamController<AppState>.broadcast();
    authStreamController = StreamController<AuthState>.broadcast();

    // Mock AppBloc
    when(() => mockAppBloc.state).thenReturn(AppInitial());
    when(() => mockAppBloc.stream)
        .thenAnswer((_) => appStreamController.stream);
    when(() => mockAppBloc.close()).thenAnswer((_) async {});

    // Mock AuthBloc
    when(() => mockAuthBloc.state).thenReturn(Authenticated(user));
    when(() => mockAuthBloc.stream)
        .thenAnswer((_) => authStreamController.stream);
    when(() => mockAuthBloc.close()).thenAnswer((_) async {});
  }

  tearDown() async {
    await appStreamController.close();
    await authStreamController.close();
  }

  Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
    await AuthScreenTestHelper.pumpAuthProtectedWidget(
      tester: tester,
      authenticatedWidget: screen,
      authBloc: mockAuthBloc,
      appBloc: mockAppBloc,
    );
  }
}
