import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/app_bloc.dart';
import '../blocs/app_state.dart';

class AppListScreen extends StatelessWidget {
  const AppListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Apps")),
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          if (state is AppLoading) {
            return Center(child: CircularProgressIndicator());
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
    );
  }
}
