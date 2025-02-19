import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/app_bloc.dart';
import '../blocs/app_event.dart';
import '../blocs/app_state.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../screens/auth/login_screen.dart';

class AppListScreen extends StatefulWidget {
  const AppListScreen({super.key});

  @override
  State<AppListScreen> createState() => _AppListScreenState();
}

class _AppListScreenState extends State<AppListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch apps when screen is first displayed
    context.read<AppBloc>().add(FetchApps());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const LoginScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(-1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Apps"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(SignOutRequested());
              },
            ),
          ],
        ),
        body: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            if (state is AppLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AppLoaded) {
              return ListView.builder(
                itemCount: state.apps.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.apps[index].name),
                    subtitle: Text("Platform: ${state.apps[index].platform}"),
                  );
                },
              );
            } else if (state is AppError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
