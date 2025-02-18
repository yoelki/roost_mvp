import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:roost_mvp/domain/usecases/get_apps.dart';
import 'package:roost_mvp/domain/repositories/app_repository.dart';
import 'package:roost_mvp/domain/entities/app_entity.dart';

import 'get_apps_test.mocks.dart';

@GenerateMocks([AppRepository])
void main() {
  late GetApps usecase;
  late MockAppRepository mockAppRepository;

  setUp(() {
    mockAppRepository = MockAppRepository();
    usecase = GetApps(mockAppRepository);
  });

  final testApps = [
    AppEntity(id: "1", name: "Test App", platform: "iOS", version: "1.0.0")
  ];

  test("should get apps from the repository", () async {
    when(mockAppRepository.getApps()).thenAnswer((_) async => testApps);

    final result = await usecase();

    expect(result, testApps);
    verify(mockAppRepository.getApps());
  });
}
