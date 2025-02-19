import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roost_mvp/presentation/blocs/auth/auth_bloc.dart';
import 'package:roost_mvp/presentation/blocs/app_bloc.dart';
import 'package:roost_mvp/presentation/widgets/auth_guard.dart';

class BlocTestHelper {
  static Widget wrapWithBlocs({
    required Widget child,
    required AuthBloc authBloc,
    required AppBloc appBloc,
  }) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>.value(value: appBloc),
          BlocProvider<AuthBloc>.value(value: authBloc),
        ],
        child: child,
      ),
    );
  }

  static StreamController<T> createBlocStream<T>() {
    return StreamController<T>.broadcast();
  }
}

extension AuthGuardTestExtensions on AuthGuard {
  Widget wrapWithBlocs({
    required AuthBloc authBloc,
    required AppBloc appBloc,
  }) {
    return BlocTestHelper.wrapWithBlocs(
      child: this,
      authBloc: authBloc,
      appBloc: appBloc,
    );
  }
}
