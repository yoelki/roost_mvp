import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roost_mvp/presentation/blocs/auth/auth_bloc.dart';
import 'package:roost_mvp/presentation/blocs/app_bloc.dart';
import 'package:roost_mvp/presentation/widgets/auth_guard.dart';
import 'package:roost_mvp/presentation/screens/auth/login_screen.dart';
import 'bloc_test_helper.dart';

class AuthScreenTestHelper {
  /// Wraps a widget with all necessary providers and auth guard for testing
  static Future<void> pumpAuthProtectedWidget({
    required WidgetTester tester,
    required Widget authenticatedWidget,
    required AuthBloc authBloc,
    required AppBloc appBloc,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocTestHelper.wrapWithBlocs(
          child: AuthGuard(
            authenticatedRoute: authenticatedWidget,
            unauthenticatedRoute: const LoginScreen(),
          ),
          authBloc: authBloc,
          appBloc: appBloc,
        ),
      ),
    );
  }
}
