import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

import 'data/datasources/firestore_data_source.dart';
import 'data/repositories/app_repository_impl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/get_apps.dart';
import 'domain/usecases/auth/sign_in.dart';
import 'domain/usecases/auth/sign_up.dart';
import 'presentation/blocs/app_bloc.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'presentation/screens/app_list_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/widgets/auth_guard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestoreDataSource = FirestoreDataSource();
  final appRepository = AppRepositoryImpl(firestoreDataSource);
  final authRepository = AuthRepositoryImpl();

  final getApps = GetApps(appRepository);
  final signIn = SignIn(authRepository);
  final signUp = SignUp(authRepository);

  runApp(RoostApp(
    getApps: getApps,
    signIn: signIn,
    signUp: signUp,
    authRepository: authRepository,
  ));
}

class RoostApp extends StatelessWidget {
  final GetApps getApps;
  final SignIn signIn;
  final SignUp signUp;
  final AuthRepository authRepository;

  const RoostApp({
    super.key,
    required this.getApps,
    required this.signIn,
    required this.signUp,
    required this.authRepository,
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
      ],
      child: MaterialApp(
        title: 'Roost MVP',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: AuthGuard(
          authenticatedRoute: const AppListScreen(),
          unauthenticatedRoute: const LoginScreen(),
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/apps': (context) => const AppListScreen(),
        },
      ),
    );
  }
}
