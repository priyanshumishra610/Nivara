import 'package:flutter/widgets.dart';
import '../services/sync_service.dart';
import '../state/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLifecycleManager extends ConsumerStatefulWidget {
  final Widget child;
  
  const AppLifecycleManager({
    required this.child,
    super.key,
  });
  
  @override
  ConsumerState<AppLifecycleManager> createState() => _AppLifecycleManagerState();
}

class _AppLifecycleManagerState extends ConsumerState<AppLifecycleManager>
    with WidgetsBindingObserver {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.resumed) {
      _onAppResumed();
    } else if (state == AppLifecycleState.paused) {
      _onAppPaused();
    }
  }
  
  void _onAppResumed() {
    final syncService = ref.read(syncServiceProvider);
    syncService.syncPendingRequests();
  }
  
  void _onAppPaused() {
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

