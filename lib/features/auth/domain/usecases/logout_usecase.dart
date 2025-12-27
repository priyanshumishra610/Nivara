import '../../../../core/utils/result.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../core/errors/app_exceptions.dart';

class LogoutUseCase {
  final AuthRepository _repository;
  
  LogoutUseCase(this._repository);
  
  Future<Result<void>> call() async {
    try {
      await _repository.logout();
      return const Success(null);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(UnknownException('Logout failed: ${e.toString()}'));
    }
  }
}

