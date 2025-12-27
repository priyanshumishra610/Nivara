import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/ai_coach_service.dart';
import '../../../../core/state/providers/app_providers.dart';
import '../../../../core/utils/result.dart';

final aiCoachServiceProvider = Provider<AICoachService>((ref) {
  return AICoachServiceImpl(
    ref.read(apiServiceProvider),
    ref.read(cacheServiceProvider),
  );
});

final aiCoachConversationProvider = StateNotifierProvider<AICoachNotifier, List<AICoachMessage>>((ref) {
  return AICoachNotifier(ref.read(aiCoachServiceProvider));
});

class AICoachNotifier extends StateNotifier<List<AICoachMessage>> {
  final AICoachService _service;
  
  AICoachNotifier(this._service) : super([]) {
    _loadHistory();
  }
  
  Future<void> _loadHistory() async {
    final result = await _service.getConversationHistory();
    if (result.isSuccess) {
      state = result.dataOrNull ?? [];
    }
  }
  
  Future<void> sendMessage(String message, {String? context}) async {
    final userMessage = AICoachMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: message,
      isUser: true,
      timestamp: DateTime.now(),
      context: context,
    );
    
    state = [...state, userMessage];
    
    final result = await _service.sendMessage(message, context: context);
    if (result.isSuccess) {
      state = [...state, result.dataOrNull!];
    }
  }
  
  void clearConversation() {
    state = [];
  }
}

final guidedSessionsProvider = FutureProvider.family<List<GuidedSession>, String>((ref, category) async {
  final service = ref.read(aiCoachServiceProvider);
  final result = await service.getGuidedSessions(category);
  return result.fold(
    onSuccess: (sessions) => sessions,
    onFailure: (error) => throw error,
  );
});

