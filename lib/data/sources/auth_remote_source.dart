import '../models/user_model.dart';
import '../../core/services/api_service.dart';
import '../../core/utils/result.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/utils/logger.dart';

abstract class AuthRemoteSource {
  Future<Result<UserModel>> login(String email, String password);
  Future<Result<UserModel>> register(String email, String password, String? name);
  Future<Result<void>> logout();
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  final ApiService _apiService;
  
  AuthRemoteSourceImpl(this._apiService);
  
  @override
  Future<Result<UserModel>> login(String email, String password) async {
    final result = await _apiService.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    
    if (result.isFailure) {
      return Failure(result.errorOrNull!);
    }
    
    try {
      final response = result.dataOrNull!;
      final data = response.data as Map<String, dynamic>;
      final userData = data['user'] as Map<String, dynamic>;
      
      final user = UserModel(
        id: userData['id'] as String,
        email: userData['email'] as String,
        name: userData['name'] as String?,
        avatarUrl: userData['avatarUrl'] as String?,
        createdAt: DateTime.parse(userData['createdAt'] as String),
      );
      
      return Success(user);
    } catch (e) {
      AppLogger.e('Failed to parse login response', e);
      return Failure(UnknownException('Failed to parse login response'));
    }
  }
  
  @override
  Future<Result<UserModel>> register(String email, String password, String? name) async {
    final result = await _apiService.post(
      '/auth/register',
      data: {'email': email, 'password': password, 'name': name},
    );
    
    if (result.isFailure) {
      return Failure(result.errorOrNull!);
    }
    
    try {
      final response = result.dataOrNull!;
      final data = response.data as Map<String, dynamic>;
      final userData = data['user'] as Map<String, dynamic>;
      
      final user = UserModel(
        id: userData['id'] as String,
        email: userData['email'] as String,
        name: userData['name'] as String?,
        avatarUrl: userData['avatarUrl'] as String?,
        createdAt: DateTime.parse(userData['createdAt'] as String),
      );
      
      return Success(user);
    } catch (e) {
      AppLogger.e('Failed to parse register response', e);
      return Failure(UnknownException('Failed to parse register response'));
    }
  }
  
  @override
  Future<Result<void>> logout() async {
    final result = await _apiService.post('/auth/logout');
    
    if (result.isFailure) {
      return Failure(result.errorOrNull!);
    }
    
    return const Success(null);
  }
}

