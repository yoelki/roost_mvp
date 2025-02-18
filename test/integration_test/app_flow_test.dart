import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:roost_mvp/data/models/app_model.dart';
import 'package:roost_mvp/main.dart';
import 'package:roost_mvp/domain/usecases/get_apps.dart';
import 'package:roost_mvp/data/repositories/app_repository_impl.dart';
import 'package:roost_mvp/data/datasources/remote_data_source.dart';
import 'package:mockito/mockito.dart';

import 'app_flow_test.mocks.dart';

// Create a separate mock for integration tests
@GenerateMocks([
  RemoteDataSource
], customMocks: [
  MockSpec<RemoteDataSource>(
    as: #IntegrationMockRemoteDataSource, // Custom name to avoid conflicts
  ),
])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Full app flow test", (WidgetTester tester) async {
    final mockDataSource = IntegrationMockRemoteDataSource();
    when(mockDataSource.getApps()).thenAnswer((_) async {
      // Add a small delay to ensure we can catch the loading state
      await Future.delayed(const Duration(milliseconds: 100));
      return [
        AppModel(id: "1", name: "Test App", platform: "iOS", version: "1.0.0"),
      ];
    });

    final getApps = GetApps(AppRepositoryImpl(mockDataSource));
    await tester.pumpWidget(RoostApp(getApps: getApps));

    // Pump once to trigger the initial build
    await tester.pump();

    // Verify loading state
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the data to load and UI to settle
    await tester.pumpAndSettle();

    // Verify loaded state
    expect(find.text("Test App"), findsOneWidget);
  });
}
