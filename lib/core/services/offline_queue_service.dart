import 'dart:convert';
import '../errors/app_exceptions.dart';
import '../utils/logger.dart';
import '../config/app_config.dart';
import 'storage_service.dart';

class OfflineRequest {
  final String id;
  final String method;
  final String path;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? queryParameters;
  final DateTime createdAt;
  
  OfflineRequest({
    required this.id,
    required this.method,
    required this.path,
    this.data,
    this.queryParameters,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'method': method,
    'path': path,
    'data': data,
    'queryParameters': queryParameters,
    'createdAt': createdAt.toIso8601String(),
  };
  
  factory OfflineRequest.fromJson(Map<String, dynamic> json) => OfflineRequest(
    id: json['id'] as String,
    method: json['method'] as String,
    path: json['path'] as String,
    data: json['data'] as Map<String, dynamic>?,
    queryParameters: json['queryParameters'] as Map<String, dynamic>?,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

abstract class OfflineQueueService {
  Future<void> addRequest(OfflineRequest request);
  Future<List<OfflineRequest>> getPendingRequests();
  Future<void> removeRequest(String requestId);
  Future<void> clear();
  Future<int> getPendingCount();
}

class OfflineQueueServiceImpl implements OfflineQueueService {
  static const String _queueKey = 'offline_queue';
  final StorageService _storage;
  
  OfflineQueueServiceImpl(this._storage);
  
  @override
  Future<void> addRequest(OfflineRequest request) async {
    try {
      final requests = await getPendingRequests();
      if (requests.length >= AppConfig.maxOfflineQueueSize) {
        AppLogger.w('Offline queue is full, removing oldest request');
        requests.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        requests.removeAt(0);
      }
      
      requests.add(request);
      await _saveRequests(requests);
    } catch (e) {
      AppLogger.e('Failed to add offline request', e);
      throw CacheException('Failed to queue offline request');
    }
  }
  
  @override
  Future<List<OfflineRequest>> getPendingRequests() async {
    try {
      final json = await _storage.getString(_queueKey);
      if (json == null) return [];
      
      final List<dynamic> data = jsonDecode(json) as List<dynamic>;
      return data.map((e) => OfflineRequest.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      AppLogger.e('Failed to get pending requests', e);
      return [];
    }
  }
  
  @override
  Future<void> removeRequest(String requestId) async {
    try {
      final requests = await getPendingRequests();
      requests.removeWhere((r) => r.id == requestId);
      await _saveRequests(requests);
    } catch (e) {
      AppLogger.e('Failed to remove offline request', e);
    }
  }
  
  @override
  Future<void> clear() async {
    try {
      await _storage.remove(_queueKey);
    } catch (e) {
      AppLogger.e('Failed to clear offline queue', e);
    }
  }
  
  @override
  Future<int> getPendingCount() async {
    final requests = await getPendingRequests();
    return requests.length;
  }
  
  Future<void> _saveRequests(List<OfflineRequest> requests) async {
    final json = jsonEncode(requests.map((r) => r.toJson()).toList());
    await _storage.setString(_queueKey, json);
  }
}

