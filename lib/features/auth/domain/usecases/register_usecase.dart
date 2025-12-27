import '../../../../core/utils/result.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../core/errors/app_exceptions.dart';

class RegisterUseCase {
  final AuthRepository _repository;
  
  RegisterUseCase(this._repository);
  
  Future<Result<UserModel>> call({
    required String email,
    required String password,
    String? name,
  }) async {
    if (email.isEmpty) {
      return Failure(ValidationException('Email is required'));
    }
    
    if (password.isEmpty) {
      return Failure(ValidationException('Password is required'));
    }
    
    try {
      final user = await _repository.register(email, password, name);
      return Success(user);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(UnknownException('Registration failed: ${e.toString()}'));
    }
  }
}

