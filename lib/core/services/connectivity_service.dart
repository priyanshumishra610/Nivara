import 'package:connectivity_plus/connectivity_plus.dart';
import '../errors/app_exceptions.dart';

abstract class ConnectivityService {
  Stream<bool> get connectivityStream;
  Future<bool> get isConnected;
}

class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  
  @override
  Stream<bool> get connectivityStream async* {
    yield await isConnected;
    await for (final result in _connectivity.onConnectivityChanged) {
      yield _isConnectionActive(result);
    }
  }
  
  @override
  Future<bool> get isConnected async {
    try {
      final result = await _connectivity.checkConnectivity();
      return _isConnectionActive(result);
    } catch (e) {
      return false;
    }
  }
  
  bool _isConnectionActive(List<ConnectivityResult> result) {
    return result.any((element) => 
      element != ConnectivityResult.none
    );
  }
}

