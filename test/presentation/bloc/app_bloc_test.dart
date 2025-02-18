import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:roost_mvp/presentation/blocs/app_bloc.dart';
import 'package:roost_mvp/presentation/blocs/app_event.dart';
import 'package:roost_mvp/presentation/blocs/app_state.dart';
import 'package:roost_mvp/domain/usecases/get_apps.dart';
import 'package:roost_mvp/domain/entities/app_entity.dart';

import 'app_bloc_test.mocks.dart';

@GenerateMocks([GetApps])
void main() {
  late AppBloc appBloc;
  late MockGetApps mockGetApps;

  setUp(() {
    mockGetApps = MockGetApps();
    appBloc = AppBloc(mockGetApps);
  });

  final testApps = [
    AppEntity(id: "1", name: "Test App", platform: "iOS", version: "1.0.0")
  ];

  blocTest<AppBloc, AppState>(
    "should emit [AppLoading, AppLoaded] when FetchApps is added",
    build: () {
      when(mockGetApps()).thenAnswer((_) async => testApps);
      return appBloc;
    },
    act: (bloc) => bloc.add(FetchApps()),
    expect: () => [AppLoading(), AppLoaded(testApps)],
  );
}
