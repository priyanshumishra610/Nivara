import 'package:logger/logger.dart' as logger;
import '../config/app_config.dart';

class AppLogger {
  static logger.Logger? _instance;
  
  static logger.Logger get instance {
    _instance ??= logger.Logger(
      printer: logger.PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      level: AppConfig.enableLogging ? logger.Level.debug : logger.Level.nothing,
    );
    return _instance!;
  }
  
  static void d(String message, [dynamic error, StackTrace? stackTrace]) {
    instance.d(message, error: error, stackTrace: stackTrace);
  }
  
  static void i(String message, [dynamic error, StackTrace? stackTrace]) {
    instance.i(message, error: error, stackTrace: stackTrace);
  }
  
  static void w(String message, [dynamic error, StackTrace? stackTrace]) {
    instance.w(message, error: error, stackTrace: stackTrace);
  }
  
  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    instance.e(message, error: error, stackTrace: stackTrace);
  }
}

