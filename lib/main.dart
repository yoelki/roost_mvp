import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

import 'data/datasources/remote_data_source.dart';
import 'data/repositories/app_repository_impl.dart';
import 'domain/usecases/get_apps.dart';
import 'presentation/blocs/app_bloc.dart';
import 'presentation/blocs/app_event.dart';
import 'presentation/screens/app_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final remoteDataSource = RemoteDataSource();
  final repository = AppRepositoryImpl(remoteDataSource);
  final getApps = GetApps(repository);

  runApp(RoostApp(getApps: getApps));
}

class RoostApp extends StatelessWidget {
  final GetApps getApps;

  const RoostApp({super.key, required this.getApps});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => AppBloc(getApps)..add(FetchApps()),
        child: const AppListScreen(),
      ),
    );
  }
}
