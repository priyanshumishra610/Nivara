import 'package:flutter/material.dart';

class LoadingOverlay {
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;
  
  static void show(BuildContext context, {String? message}) {
    if (_isVisible) return;
    
    _overlayEntry = OverlayEntry(
      builder: (context) => _LoadingWidget(message: message),
    );
    
    Overlay.of(context).insert(_overlayEntry!);
    _isVisible = true;
  }
  
  static void hide() {
    if (!_isVisible) return;
    
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isVisible = false;
  }
}

class _LoadingWidget extends StatelessWidget {
  final String? message;
  
  const _LoadingWidget({this.message});
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

