import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/chat_message.dart';
import '../../services/chat_history_service.dart';

final chatHistoryServiceProvider = Provider<ChatHistoryService>((ref) {
  return ChatHistoryService();
});

/// Current conversation ID
final currentConversationProvider = StateProvider<String?>((ref) {
  return null;
});

/// Get all user conversations
final conversationsProvider = FutureProvider<List<Conversation>>((ref) async {
  final service = ref.watch(chatHistoryServiceProvider);
  return service.getConversations();
});

/// Stream messages for current conversation
final currentConversationMessagesProvider =
    StreamProvider<List<ChatMessage>>((ref) async* {
  final conversationId = ref.watch(currentConversationProvider);
  if (conversationId == null) {
    yield [];
    return;
  }

  final service = ref.watch(chatHistoryServiceProvider);
  yield* service.streamConversationMessages(conversationId);
});

/// Create new conversation
final createConversationProvider =
    FutureProvider.family<String, String>((ref, title) async {
  final service = ref.watch(chatHistoryServiceProvider);
  final conversationId = await service.createConversation(title);
  ref.read(currentConversationProvider.notifier).state = conversationId;
  return conversationId;
});

/// Save a message
final saveMessageProvider =
    FutureProvider.family<void, ChatMessage>((ref, message) async {
  final service = ref.watch(chatHistoryServiceProvider);
  await service.saveMessage(message);
});

/// Delete a conversation
final deleteConversationProvider =
    FutureProvider.family<void, String>((ref, conversationId) async {
  final service = ref.watch(chatHistoryServiceProvider);
  await service.deleteConversation(conversationId);
  
  // If this was the current conversation, clear it
  if (ref.read(currentConversationProvider) == conversationId) {
    ref.read(currentConversationProvider.notifier).state = null;
  }
});

/// Update conversation title
final updateConversationTitleProvider = FutureProvider
    .family<void, ({String conversationId, String title})>((ref, params) async {
  final service = ref.watch(chatHistoryServiceProvider);
  await service.updateConversationTitle(params.conversationId, params.title);
});
