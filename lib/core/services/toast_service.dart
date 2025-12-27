import 'package:flutter/material.dart';

abstract class ToastService {
  void showSuccess(String message);
  void showError(String message);
  void showInfo(String message);
  void showWarning(String message);
}

class ToastServiceImpl implements ToastService {
  final GlobalKey<NavigatorState> navigatorKey;
  
  ToastServiceImpl(this.navigatorKey);
  
  BuildContext? get _context => navigatorKey.currentContext;
  
  @override
  void showSuccess(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline,
    );
  }
  
  @override
  void showError(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.red,
      icon: Icons.error_outline,
    );
  }
  
  @override
  void showInfo(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.blue,
      icon: Icons.info_outline,
    );
  }
  
  @override
  void showWarning(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.orange,
      icon: Icons.warning_amber_rounded,
    );
  }
  
  void _showSnackBar(
    String message, {
    required Color backgroundColor,
    required IconData icon,
  }) {
    final context = _context;
    if (context == null) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

