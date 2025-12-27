import 'dart:async';
import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../errors/app_exceptions.dart';
import '../utils/logger.dart';
import '../utils/result.dart';
import 'connectivity_service.dart';
import 'token_manager.dart';

abstract class ApiService {
  Future<Result<Response>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  });
  
  Future<Result<Response>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });
  
  Future<Result<Response>> put(
    String path, {
    dynamic data,
    Options? options,
  });
  
  Future<Result<Response>> delete(
    String path, {
    Options? options,
  });
  
  Future<Result<Response>> patch(
    String path, {
    dynamic data,
    Options? options,
  });
  
  void setAuthToken(String? token);
}

class DioApiService implements ApiService {
  late final Dio _dio;
  final ConnectivityService _connectivityService;
  final TokenManager _tokenManager;
  
  DioApiService(
    this._connectivityService,
    this._tokenManager,
  ) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: AppConfig.apiConnectTimeout,
        receiveTimeout: AppConfig.apiReceiveTimeout,
        headers: AppConfig.defaultHeaders,
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers.addAll(AppConfig.defaultHeaders);
          
          if (AppConfig.enableNetworkLogging) {
            AppLogger.d(
              'REQUEST[${options.method}] => PATH: ${options.path}',
            );
            if (options.queryParameters.isNotEmpty) {
              AppLogger.d('QueryParams: ${options.queryParameters}');
            }
          }
          
          final token = await _tokenManager.getAccessToken();
          if (token != null && !options.path.contains('/auth/')) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (AppConfig.enableNetworkLogging) {
            AppLogger.d(
              'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
            );
          }
          handler.next(response);
        },
        onError: (error, handler) async {
          if (AppConfig.enableNetworkLogging) {
            AppLogger.e(
              'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
            );
          }
          
          if (error.response?.statusCode == 401 && 
              !error.requestOptions.path.contains('/auth/refresh')) {
            try {
              final newToken = await _tokenManager.refreshTokenIfNeeded();
              if (newToken != null) {
                error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                final opts = Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                );
                final cloneReq = await _dio.request(
                  error.requestOptions.path,
                  options: opts,
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters,
                );
                return handler.resolve(cloneReq);
              }
            } catch (e) {
              AppLogger.e('Token refresh failed', e);
            }
          }
          
          handler.next(error);
        },
      ),
    );
    
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.requestOptions.extra['retries'] == null) {
            error.requestOptions.extra['retries'] = 0;
          }
          
          final retries = error.requestOptions.extra['retries'] as int;
          final shouldRetry = retries < AppConfig.maxRetries &&
              _shouldRetry(error);
          
          if (shouldRetry) {
            error.requestOptions.extra['retries'] = retries + 1;
            final delay = AppConfig.retryDelay + 
                (AppConfig.retryBackoffMultiplier * retries);
            await Future.delayed(delay);
            
            AppLogger.i('Retrying request (${retries + 1}/${AppConfig.maxRetries})');
            
            try {
              final response = await _dio.request(
                error.requestOptions.path,
                options: Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                ),
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
              );
              return handler.resolve(response);
            } catch (e) {
              handler.next(error);
            }
          } else {
            handler.next(error);
          }
        },
      ),
    );
  }
  
  @override
  Future<Result<Response>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _handleRequest(() => _dio.get(path, queryParameters: queryParameters, options: options));
  }
  
  @override
  Future<Result<Response>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _handleRequest(() => _dio.post(path, data: data, queryParameters: queryParameters, options: options));
  }
  
  @override
  Future<Result<Response>> put(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    return _handleRequest(() => _dio.put(path, data: data, options: options));
  }
  
  @override
  Future<Result<Response>> delete(
    String path, {
    Options? options,
  }) async {
    return _handleRequest(() => _dio.delete(path, options: options));
  }
  
  @override
  Future<Result<Response>> patch(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    return _handleRequest(() => _dio.patch(path, data: data, options: options));
  }
  
  @override
  void setAuthToken(String? token) {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }
  
  Future<Result<Response>> _handleRequest(Future<Response> Function() request) async {
    try {
      final isConnected = await _connectivityService.isConnected;
      if (!isConnected) {
        return Failure(NetworkException('No internet connection'));
      }
      
      final response = await request();
      return Success(response);
    } on DioException catch (e) {
      return Failure(_handleDioError(e));
    } catch (e) {
      AppLogger.e('Unexpected API error', e);
      return Failure(UnknownException('An unexpected error occurred'));
    }
  }
  
  bool _shouldRetry(DioException error) {
    if (error.requestOptions.method == 'GET' ||
        error.requestOptions.method == 'HEAD') {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError) {
        return true;
      }
      
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        return statusCode >= 500 && statusCode < 600;
      }
    }
    
    return false;
  }
  
  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Request timeout. Please check your connection.');
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] as String? ?? 
                       error.response?.statusMessage ?? 
                       'Server error';
        
        switch (statusCode) {
          case 400:
            return ValidationException(message);
          case 401:
            return AuthenticationException('Authentication failed');
          case 403:
            return AuthorizationException('Access denied');
          case 404:
            return ServerException('Resource not found');
          case 500:
          case 502:
          case 503:
            return ServerException('Server error. Please try again later.');
          default:
            return ServerException(message);
        }
      
      case DioExceptionType.cancel:
        return NetworkException('Request cancelled');
      
      case DioExceptionType.connectionError:
        return NetworkException('Connection error. Please check your internet.');
      
      default:
        return NetworkException('Network error: ${error.message}');
    }
  }
}
