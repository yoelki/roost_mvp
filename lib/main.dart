import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

import 'data/datasources/firestore_data_source.dart';
import 'data/repositories/app_repository_impl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/get_apps.dart';
import 'domain/usecases/auth/sign_in.dart';
import 'domain/usecases/auth/sign_up.dart';
import 'domain/usecases/settings/get_settings.dart';
import 'domain/usecases/settings/update_settings.dart';
import 'presentation/blocs/app_bloc.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'presentation/blocs/settings/settings_bloc.dart';
import 'presentation/blocs/settings/settings_event.dart';
import 'presentation/screens/app_list_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/widgets/auth_guard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();

  final firestoreDataSource = FirestoreDataSource();
  final appRepository = AppRepositoryImpl(firestoreDataSource);
  final authRepository = AuthRepositoryImpl();
  final settingsRepository = SettingsRepositoryImpl(prefs);

  final getApps = GetApps(appRepository);
  final signIn = SignIn(authRepository);
  final signUp = SignUp(authRepository);
  final getSettings = GetSettings(settingsRepository);
  final updateSettings = UpdateSettings(settingsRepository);

  runApp(RoostApp(
    getApps: getApps,
    signIn: signIn,
    signUp: signUp,
    authRepository: authRepository,
    getSettings: getSettings,
    updateSettings: updateSettings,
  ));
}

class RoostApp extends StatelessWidget {
  final GetApps getApps;
  final SignIn signIn;
  final SignUp signUp;
  final AuthRepository authRepository;
  final GetSettings getSettings;
  final UpdateSettings updateSettings;

  const RoostApp({
    super.key,
    required this.getApps,
    required this.signIn,
    required this.signUp,
    required this.authRepository,
    required this.getSettings,
    required this.updateSettings,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            signIn: signIn,
            signUp: signUp,
            authRepository: authRepository,
          )..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (context) => AppBloc(getApps),
        ),
        BlocProvider(
          create: (context) => SettingsBloc(
            getSettings: getSettings,
            updateSettings: updateSettings,
          )..add(LoadSettings()),
        ),
      ],
      child: MaterialApp(
        title: 'Roost MVP',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            },
          ),
        ),
        home: AuthGuard(
          authenticatedRoute: const AppListScreen(),
          unauthenticatedRoute: const LoginScreen(),
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/apps': (context) => const AppListScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
