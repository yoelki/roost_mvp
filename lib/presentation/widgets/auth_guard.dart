import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roost_mvp/presentation/blocs/auth/auth_bloc.dart';
import 'package:roost_mvp/presentation/blocs/auth/auth_state.dart';

class AuthGuard extends StatelessWidget {
  final Widget authenticatedRoute;
  final Widget unauthenticatedRoute;

  const AuthGuard({
    required this.authenticatedRoute,
    required this.unauthenticatedRoute,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return authenticatedRoute;
        }
        return unauthenticatedRoute;
      },
    );
  }
}
