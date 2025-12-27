import '../../../../core/utils/result.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../core/errors/app_exceptions.dart';

class LoginUseCase {
  final AuthRepository _repository;
  
  LoginUseCase(this._repository);
  
  Future<Result<UserModel>> call(String email, String password) async {
    if (email.isEmpty) {
      return Failure(ValidationException('Email is required'));
    }
    
    if (password.isEmpty) {
      return Failure(ValidationException('Password is required'));
    }
    
    try {
      final user = await _repository.login(email, password);
      return Success(user);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(UnknownException('Login failed: ${e.toString()}'));
    }
  }
}

