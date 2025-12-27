import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import '../../../../lib/core/services/api_service.dart';
import '../../../../lib/core/services/connectivity_service.dart';
import '../../../../lib/core/services/token_manager.dart';
import '../../../../lib/core/errors/app_exceptions.dart';
import '../../../../lib/core/utils/result.dart';
import '../../helpers/mock_services.dart';

void main() {
  late DioApiService apiService;
  late MockConnectivityService mockConnectivity;
  late MockTokenManager mockTokenManager;
  
  setUp(() {
    mockConnectivity = MockConnectivityService();
    mockTokenManager = MockTokenManager();
    apiService = DioApiService(mockConnectivity, mockTokenManager);
    
    when(() => mockConnectivity.isConnected).thenAnswer((_) async => true);
    when(() => mockTokenManager.getAccessToken()).thenAnswer((_) async => null);
  });
  
  group('ApiService', () {
    test('should return failure when offline', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => false);
      
      final result = await apiService.get('/test');
      
      expect(result.isFailure, true);
      expect(result.errorOrNull, isA<NetworkException>());
    });
    
    test('should handle network errors correctly', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => true);
      
      final result = await apiService.get('/test');
      
      expect(result.isFailure, true);
    });
  });
}
