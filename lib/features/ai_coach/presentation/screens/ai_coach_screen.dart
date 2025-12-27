import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/services/ai_coach_service.dart';
import '../providers/ai_coach_provider.dart';

class AICoachScreen extends ConsumerStatefulWidget {
  const AICoachScreen({super.key});
  
  @override
  ConsumerState<AICoachScreen> createState() => _AICoachScreenState();
}

class _AICoachScreenState extends ConsumerState<AICoachScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  
  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isLoading) return;
    
    setState(() {
      _isLoading = true;
    });
    
    _messageController.clear();
    
    await ref.read(aiCoachConversationProvider.notifier).sendMessage(message);
    _scrollToBottom();
    
    setState(() {
      _isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(aiCoachConversationProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Wellness Coach'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              ref.read(aiCoachConversationProvider.notifier).clearConversation();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(context, messages[index]);
                    },
                  ),
          ),
          _buildInputArea(context),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: AppColors.wellnessGradient,
              shape: BoxShape.circle,
              boxShadow: [AppColors.floatingShadow],
            ),
            child: const Icon(
              Icons.psychology,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Your AI Wellness Coach',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              'I\'m here to support you on your wellness journey. Ask me anything, and I\'ll listen with empathy and understanding.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMessageBubble(BuildContext context, AICoachMessage message) {
    final isUser = message.isUser;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.wellnessGradient,
                shape: BoxShape.circle,
                boxShadow: [AppColors.cardShadow],
              ),
              child: const Icon(
                Icons.psychology,
                size: 22,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                gradient: isUser
                    ? AppColors.primaryGradient
                    : null,
                color: isUser
                    ? null
                    : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: isUser ? [AppColors.cardShadow] : null,
                border: isUser
                    ? null
                    : Border.all(color: AppColors.border.withOpacity(0.5)),
              ),
              child: Text(
                message.content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isUser ? Colors.white : AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: AppSpacing.sm),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.calmGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 22,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton(
              onPressed: _isLoading ? null : _sendMessage,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(AppSpacing.md),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

