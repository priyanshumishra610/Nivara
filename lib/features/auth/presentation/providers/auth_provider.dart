import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/auth_state.dart';
import '../../../../state/providers/app_providers.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final AuthService _authService;
  
  AuthNotifier(this._authRepository, this._authService) : super(const AuthState()) {
    _checkAuthStatus();
  }
  
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    final isAuthenticated = await _authService.isAuthenticated();
    state = state.copyWith(
      isAuthenticated: isAuthenticated,
      isLoading: false,
    );
  }
  
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _authRepository.login(email, password);
    
    return result.fold(
      onSuccess: (user) {
        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
          user: user,
          error: null,
        );
        return true;
      },
      onFailure: (error) {
        state = state.copyWith(
          isLoading: false,
          error: error.message,
        );
        return false;
      },
    );
  }
  
  Future<bool> register(String email, String password, String? name) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _authRepository.register(email, password, name);
    
    return result.fold(
      onSuccess: (user) {
        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
          user: user,
          error: null,
        );
        return true;
      },
      onFailure: (error) {
        state = state.copyWith(
          isLoading: false,
          error: error.message,
        );
        return false;
      },
    );
  }
  
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _authRepository.logout();
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.read(authRepositoryProvider),
    ref.read(authServiceProvider),
  );
});

