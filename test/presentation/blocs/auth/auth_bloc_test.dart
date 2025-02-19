import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:roost_mvp/domain/entities/user_entity.dart';
import 'package:roost_mvp/domain/repositories/auth_repository.dart';
import 'package:roost_mvp/domain/usecases/auth/sign_in.dart';
import 'package:roost_mvp/domain/usecases/auth/sign_up.dart';
import 'package:roost_mvp/presentation/blocs/auth/auth_bloc.dart';
import 'package:roost_mvp/presentation/blocs/auth/auth_event.dart';
import 'package:roost_mvp/presentation/blocs/auth/auth_state.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([SignIn, SignUp, AuthRepository])
void main() {
  late AuthBloc authBloc;
  late MockSignIn mockSignIn;
  late MockSignUp mockSignUp;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockSignIn = MockSignIn();
    mockSignUp = MockSignUp();
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(
      signIn: mockSignIn,
      signUp: mockSignUp,
      authRepository: mockAuthRepository,
    );
  });

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  final testUser = UserEntity(id: '1', email: testEmail);

  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when SignInRequested is successful',
      build: () {
        when(mockSignIn(testEmail, testPassword))
            .thenAnswer((_) async => testUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(SignInRequested(testEmail, testPassword)),
      expect: () => [
        AuthLoading(),
        Authenticated(testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when SignUpRequested is successful',
      build: () {
        when(mockSignUp(testEmail, testPassword))
            .thenAnswer((_) async => testUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpRequested(testEmail, testPassword)),
      expect: () => [
        AuthLoading(),
        Authenticated(testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] when SignOutRequested is successful',
      build: () {
        when(mockAuthRepository.signOut()).thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(SignOutRequested()),
      expect: () => [
        AuthLoading(),
        Unauthenticated(),
      ],
    );
  });
}
