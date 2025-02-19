import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  Future<UserEntity> call(String email, String password) async {
    return await repository.signInWithEmailAndPassword(email, password);
  }
}
