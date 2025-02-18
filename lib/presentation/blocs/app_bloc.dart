import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_apps.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final GetApps getApps;

  AppBloc(this.getApps) : super(AppInitial()) {
    on<FetchApps>((event, emit) async {
      emit(AppLoading());
      try {
        final apps = await getApps();
        emit(AppLoaded(apps));
      } catch (e) {
        emit(AppError("Failed to load apps"));
      }
    });
  }
}
