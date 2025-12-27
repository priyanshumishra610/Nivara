import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nivara/core/errors/app_exceptions.dart';
import 'package:nivara/core/utils/result.dart';
import 'package:nivara/data/models/user_model.dart';
import 'package:nivara/data/repositories/auth_repository.dart';
import 'package:nivara/data/sources/auth_remote_source.dart';
import 'package:nivara/core/services/auth_service.dart';

class MockAuthRemoteSource extends Mock implements AuthRemoteSource {}
class MockAuthService extends Mock implements AuthService {}

void main() {
  late AuthRepository repository;
  late MockAuthRemoteSource mockRemoteSource;
  late MockAuthService mockAuthService;

  setUp(() {
    mockRemoteSource = MockAuthRemoteSource();
    mockAuthService = MockAuthService();
    repository = AuthRepositoryImpl(mockRemoteSource, mockAuthService);
  });

  group('AuthRepository', () {
    final testUser = UserModel(
      id: '1',
      email: 'test@example.com',
      name: 'Test User',
      createdAt: DateTime.now(),
    );

    test('login should return user on success', () async {
      when(() => mockRemoteSource.login(any(), any()))
          .thenAnswer((_) async => Success(testUser));
      when(() => mockAuthService.saveToken(any()))
          .thenAnswer((_) async => Future.value());
      when(() => mockAuthService.saveUserId(any()))
          .thenAnswer((_) async => Future.value());

      final result = await repository.login('test@example.com', 'password');

      expect(result.isSuccess, true);
      expect(result.dataOrNull, testUser);
      verify(() => mockAuthService.saveToken(any())).called(1);
      verify(() => mockAuthService.saveUserId(testUser.id)).called(1);
    });

    test('login should return failure on remote source failure', () async {
      final error = NetworkException('Network error');
      when(() => mockRemoteSource.login(any(), any()))
          .thenAnswer((_) async => Failure(error));

      final result = await repository.login('test@example.com', 'password');

      expect(result.isFailure, true);
      expect(result.errorOrNull, error);
    });

    test('logout should clear auth data', () async {
      when(() => mockRemoteSource.logout())
          .thenAnswer((_) async => const Success(null));
      when(() => mockAuthService.logout())
          .thenAnswer((_) async => Future.value());

      final result = await repository.logout();

      expect(result.isSuccess, true);
      verify(() => mockAuthService.logout()).called(1);
    });
  });
}

