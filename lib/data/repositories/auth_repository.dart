import '../models/user_model.dart';
import '../sources/auth_remote_source.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/result.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/utils/logger.dart';

abstract class AuthRepository {
  Future<Result<UserModel>> login(String email, String password);
  Future<Result<UserModel>> register(String email, String password, String? name);
  Future<Result<void>> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource _remoteSource;
  final AuthService _authService;
  
  AuthRepositoryImpl(this._remoteSource, this._authService);
  
  @override
  Future<Result<UserModel>> login(String email, String password) async {
    final result = await _remoteSource.login(email, password);
    
    if (result.isFailure) {
      return Failure(result.errorOrNull!);
    }
    
    final user = result.dataOrNull!;
    try {
      await _authService.saveToken('token_placeholder');
      await _authService.saveUserId(user.id);
      return Success(user);
    } catch (e) {
      AppLogger.e('Failed to save auth data', e);
      return Failure(UnknownException('Failed to save authentication data'));
    }
  }
  
  @override
  Future<Result<UserModel>> register(String email, String password, String? name) async {
    final result = await _remoteSource.register(email, password, name);
    
    if (result.isFailure) {
      return Failure(result.errorOrNull!);
    }
    
    final user = result.dataOrNull!;
    try {
      await _authService.saveToken('token_placeholder');
      await _authService.saveUserId(user.id);
      return Success(user);
    } catch (e) {
      AppLogger.e('Failed to save auth data', e);
      return Failure(UnknownException('Failed to save authentication data'));
    }
  }
  
  @override
  Future<Result<void>> logout() async {
    final result = await _remoteSource.logout();
    await _authService.logout();
    
    if (result.isFailure) {
      return Failure(result.errorOrNull!);
    }
    
    return const Success(null);
  }
}

