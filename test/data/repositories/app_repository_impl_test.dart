import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:roost_mvp/data/repositories/app_repository_impl.dart';
import 'package:roost_mvp/data/datasources/firestore_data_source.dart';
import 'package:roost_mvp/data/models/app_model.dart';

import 'app_repository_impl_test.mocks.dart';

@GenerateMocks([FirestoreDataSource])
void main() {
  late AppRepositoryImpl repository;
  late MockFirestoreDataSource mockFirestoreDataSource;

  setUp(() {
    mockFirestoreDataSource = MockFirestoreDataSource();
    repository = AppRepositoryImpl(mockFirestoreDataSource);
  });

  final testApps = [
    AppModel(id: "1", name: "Test App", platform: "iOS", version: "1.0.0")
  ];

  test("should return apps from remote data source", () async {
    when(mockFirestoreDataSource.getApps()).thenAnswer((_) async => testApps);

    final result = await repository.getApps();

    expect(result, testApps);
    verify(mockFirestoreDataSource.getApps());
  });
}
