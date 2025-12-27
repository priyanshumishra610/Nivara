import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app_exceptions.dart';
import '../utils/logger.dart';
import '../config/app_config.dart';

class GlobalExceptionHandler {
  static void initialize() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      if (!kDebugMode && AppConfig.enableCrashReporting) {
        _logError(details.exception, details.stack);
      }
    };
    
    PlatformDispatcher.instance.onError = (error, stack) {
      _logError(error, stack);
      return true;
    };
  }
  
  static void _logError(dynamic error, StackTrace? stack) {
    AppLogger.e(
      'Uncaught exception',
      error,
      stack,
    );
  }
  
  static AppException handleException(dynamic error) {
    if (error is AppException) {
      return error;
    }
    
    AppLogger.e('Handling exception', error);
    
    if (error is FormatException) {
      return ValidationException('Invalid data format: ${error.message}');
    }
    
    if (error is TimeoutException) {
      return NetworkException('Request timeout. Please check your connection.');
    }
    
    return UnknownException('An unexpected error occurred: ${error.toString()}');
  }
}

