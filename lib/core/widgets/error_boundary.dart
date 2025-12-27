import 'package:flutter/material.dart';
import '../errors/app_exceptions.dart';
import '../utils/logger.dart';
import 'error_screen.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, AppException error)? errorBuilder;
  
  const ErrorBoundary({
    required this.child,
    this.errorBuilder,
    super.key,
  });
  
  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  AppException? _error;
  
  @override
  void initState() {
    super.initState();
    FlutterError.onError = (details) {
      setState(() {
        _error = UnknownException(details.exceptionAsString());
      });
      AppLogger.e('Error caught by boundary', details.exception, details.stack);
    };
  }
  
  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(context, _error!) ?? 
        _defaultErrorWidget(context, _error!);
    }
    return widget.child;
  }
  
  Widget _defaultErrorWidget(BuildContext context, AppException error) {
    return ErrorScreen(
      error: error,
      onRetry: () {
        setState(() {
          _error = null;
        });
      },
    );
  }
}

