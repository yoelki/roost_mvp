import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:roost_mvp/main.dart';
import 'package:roost_mvp/domain/usecases/get_apps.dart';
import 'package:roost_mvp/data/repositories/app_repository_impl.dart';
import 'package:roost_mvp/data/datasources/remote_data_source.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("Full app flow test", (WidgetTester tester) async {
    final getApps = GetApps(AppRepositoryImpl(RemoteDataSource()));
    await tester.pumpWidget(RoostApp(getApps: getApps));

    expect(find.text("Loading..."), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text("Test App"), findsOneWidget);
  });
}
