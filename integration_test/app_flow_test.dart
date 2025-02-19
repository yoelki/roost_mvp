import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:roost_mvp/data/models/app_model.dart';
import 'package:roost_mvp/main.dart';
import 'package:roost_mvp/domain/usecases/get_apps.dart';
import 'package:roost_mvp/data/repositories/app_repository_impl.dart';
import 'package:roost_mvp/data/datasources/firestore_data_source.dart';
import 'package:mockito/mockito.dart';
import 'package:roost_mvp/domain/usecases/auth/sign_in.dart';
import 'package:roost_mvp/domain/usecases/auth/sign_up.dart';
import 'package:roost_mvp/data/repositories/auth_repository_impl.dart';
import 'package:roost_mvp/domain/entities/user_entity.dart';

import 'app_flow_test.mocks.dart';

// Create a separate mock for integration tests
@GenerateMocks([
  FirestoreDataSource,
  AuthRepositoryImpl,
], customMocks: [
  MockSpec<FirestoreDataSource>(
    as: #IntegrationMockFirestoreDataSource,
  ),
])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Flow Tests', () {
    late IntegrationMockFirestoreDataSource mockDataSource;
    late MockAuthRepositoryImpl mockAuthRepository;
    late UserEntity testUser;

    setUp(() {
      mockDataSource = IntegrationMockFirestoreDataSource();
      mockAuthRepository = MockAuthRepositoryImpl();
      testUser = UserEntity(id: '1', email: 'test@example.com');

      // Mock auth state changes stream with delay
      when(mockAuthRepository.authStateChanges).thenAnswer(
        (_) => Stream.fromIterable([null, testUser]).asyncMap((user) async {
          await Future.delayed(const Duration(seconds: 1));
          return user;
        }),
      );

      // Mock initial unauthenticated state
      when(mockAuthRepository.currentUser).thenReturn(null);

      // Mock sign in with longer delay
      when(mockAuthRepository.signInWithEmailAndPassword(any, any))
          .thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 2));
        return testUser;
      });

      // Mock apps data with delay
      when(mockDataSource.getApps()).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
        return [
          AppModel(
            id: "1",
            name: "Test App",
            platform: "iOS",
            version: "1.0.0",
          ),
        ];
      });
    });

    testWidgets("Full app flow test", (WidgetTester tester) async {
      final getApps = GetApps(AppRepositoryImpl(mockDataSource));

      await tester.pumpWidget(RoostApp(
        getApps: getApps,
        signIn: SignIn(mockAuthRepository),
        signUp: SignUp(mockAuthRepository),
        authRepository: mockAuthRepository,
      ));

      // Initial pause to see the login screen
      await tester.pump();
      await Future.delayed(const Duration(seconds: 2));

      // Verify we start at login screen
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
      await tester.pump();
      await Future.delayed(const Duration(seconds: 1));

      // Enter email with pause
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.pump();
      await Future.delayed(const Duration(seconds: 1));

      // Enter password with pause
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );
      await tester.pump();
      await Future.delayed(const Duration(seconds: 2));

      // Tap login button
      await tester.tap(find.byKey(const Key('sign_in_button')));
      await tester.pump();
      await Future.delayed(const Duration(seconds: 1));

      // Verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));

      // Allow animations to complete
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      // Verify navigation to app list screen
      expect(find.text('Apps'), findsOneWidget);
      await tester.pump();
      await Future.delayed(const Duration(seconds: 1));

      expect(find.text('Test App'), findsOneWidget);
      expect(find.text('Platform: iOS'), findsOneWidget);
      await tester.pump();
      await Future.delayed(const Duration(seconds: 2));

      // Verify logout button is present
      expect(find.byIcon(Icons.logout), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));

      // Verify sign in was called with correct credentials
      verify(mockAuthRepository.signInWithEmailAndPassword(
        'test@example.com',
        'password123',
      )).called(1);
    });
  });
}
