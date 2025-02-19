import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:roost_mvp/domain/usecases/auth/sign_in.dart';
import 'package:roost_mvp/domain/repositories/auth_repository.dart';
import 'package:roost_mvp/domain/entities/user_entity.dart';

import 'sign_in_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SignIn usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SignIn(mockAuthRepository);
  });

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  final testUser = UserEntity(id: '1', email: testEmail);

  test('should sign in user with email and password', () async {
    when(mockAuthRepository.signInWithEmailAndPassword(
      testEmail,
      testPassword,
    )).thenAnswer((_) async => testUser);

    final result = await usecase(testEmail, testPassword);

    expect(result, testUser);
    verify(mockAuthRepository.signInWithEmailAndPassword(
      testEmail,
      testPassword,
    ));
  });
}
