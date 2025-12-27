import '../errors/app_exceptions.dart';
import '../utils/logger.dart';
import '../utils/result.dart';
import 'api_service.dart';
import 'offline_queue_service.dart';
import 'connectivity_service.dart';

abstract class SyncService {
  Future<Result<void>> syncPendingRequests();
  Future<bool> isSyncing();
}

class SyncServiceImpl implements SyncService {
  final ApiService _apiService;
  final OfflineQueueService _offlineQueue;
  final ConnectivityService _connectivityService;
  bool _isSyncing = false;
  
  SyncServiceImpl(
    this._apiService,
    this._offlineQueue,
    this._connectivityService,
  );
  
  @override
  Future<bool> isSyncing() => Future.value(_isSyncing);
  
  @override
  Future<Result<void>> syncPendingRequests() async {
    if (_isSyncing) {
      return const Success(null);
    }
    
    final isConnected = await _connectivityService.isConnected;
    if (!isConnected) {
      return Failure(NetworkException('No internet connection'));
    }
    
    _isSyncing = true;
    
    try {
      final requests = await _offlineQueue.getPendingRequests();
      if (requests.isEmpty) {
        _isSyncing = false;
        return const Success(null);
      }
      
      AppLogger.i('Syncing ${requests.length} pending requests');
      
      final failedRequests = <String>[];
      
      for (final request in requests) {
        try {
          final result = await _executeRequest(request);
          if (result.isSuccess) {
            await _offlineQueue.removeRequest(request.id);
            AppLogger.d('Synced request: ${request.id}');
          } else {
            failedRequests.add(request.id);
            AppLogger.w('Failed to sync request: ${request.id}');
          }
        } catch (e) {
          AppLogger.e('Error syncing request: ${request.id}', e);
          failedRequests.add(request.id);
        }
      }
      
      _isSyncing = false;
      
      if (failedRequests.isEmpty) {
        return const Success(null);
      } else {
        return Failure(
          ServerException('Failed to sync ${failedRequests.length} requests'),
        );
      }
    } catch (e) {
      _isSyncing = false;
      AppLogger.e('Sync failed', e);
      return Failure(UnknownException('Sync operation failed'));
    }
  }
  
  Future<Result<void>> _executeRequest(OfflineRequest request) async {
    switch (request.method.toUpperCase()) {
      case 'GET':
        final result = await _apiService.get(
          request.path,
          queryParameters: request.queryParameters,
        );
        return result.fold(
          onSuccess: (_) => const Success(null),
          onFailure: (error) => Failure(error),
        );
      
      case 'POST':
        final result = await _apiService.post(
          request.path,
          data: request.data,
          queryParameters: request.queryParameters,
        );
        return result.fold(
          onSuccess: (_) => const Success(null),
          onFailure: (error) => Failure(error),
        );
      
      case 'PUT':
        final result = await _apiService.put(
          request.path,
          data: request.data,
        );
        return result.fold(
          onSuccess: (_) => const Success(null),
          onFailure: (error) => Failure(error),
        );
      
      case 'PATCH':
        final result = await _apiService.patch(
          request.path,
          data: request.data,
        );
        return result.fold(
          onSuccess: (_) => const Success(null),
          onFailure: (error) => Failure(error),
        );
      
      case 'DELETE':
        final result = await _apiService.delete(request.path);
        return result.fold(
          onSuccess: (_) => const Success(null),
          onFailure: (error) => Failure(error),
        );
      
      default:
        return Failure(ValidationException('Unsupported method: ${request.method}'));
    }
  }
}

