import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:roost_mvp/data/repositories/app_repository_impl.dart';
import 'package:roost_mvp/data/datasources/remote_data_source.dart';
import 'package:roost_mvp/data/models/app_model.dart';

import 'app_repository_impl_test.mocks.dart';

@GenerateMocks([RemoteDataSource])
void main() {
  late AppRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = AppRepositoryImpl(mockRemoteDataSource);
  });

  final testApps = [
    AppModel(id: "1", name: "Test App", platform: "iOS", version: "1.0.0")
  ];

  test("should return apps from remote data source", () async {
    when(mockRemoteDataSource.getApps()).thenAnswer((_) async => testApps);

    final result = await repository.getApps();

    expect(result, testApps);
    verify(mockRemoteDataSource.getApps());
  });
}
