import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/chat_message.dart';
import '../../widgets/markdown_message.dart';
import 'chat_history_provider.dart';
import 'openai_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // Initialize or load conversations on first build
    Future.microtask(() => _ensureConversation());
  }

  Future<void> _ensureConversation() async {
    final conversationId = ref.read(currentConversationProvider);
    if (conversationId == null) {
      // Create a new conversation if none exists
      try {
        await ref.read(createConversationProvider('New Chat').future);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating conversation: $e')),
        );
      }
    }
  }

  Future<void> _send(WidgetRef ref) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final conversationId = ref.read(currentConversationProvider);
    if (conversationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No conversation selected')),
      );
      return;
    }

    // Create user message
    final userMessage = ChatMessage(
      conversationId: conversationId,
      text: text,
      isUser: true,
    );

    // Save user message
    try {
      await ref.read(saveMessageProvider(userMessage).future);
      _controller.clear();
      setState(() => _loading = true);

      // Get AI response
      final response = await ref.read(chatResponseProvider(text).future);

      // Create and save AI message
      final aiMessage = ChatMessage(
        conversationId: conversationId,
        text: response,
        isUser: false,
      );

      await ref.read(saveMessageProvider(aiMessage).future);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentConvId = ref.watch(currentConversationProvider);
    final messagesAsync = ref.watch(currentConversationMessagesProvider);
    final conversationsAsync = ref.watch(conversationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showNewConversationDialog(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Conversation selector
            conversationsAsync.when(
              data: (conversations) {
                if (conversations.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    child: const Text('No conversations',
                        style: TextStyle(color: Colors.white70)),
                  );
                }
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: conversations
                          .map((conv) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: FilterChip(
                                  label: Text(conv.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  selected: conv.id == currentConvId,
                                  onSelected: (_) {
                                    ref
                                        .read(currentConversationProvider
                                            .notifier)
                                        .state = conv.id;
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(height: 32, width: 32, child: CircularProgressIndicator()),
              ),
              error: (e, st) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
              ),
            ),
            const Divider(height: 1),
            // Messages list
            Expanded(
              child: messagesAsync.when(
                data: (messages) {
                  if (messages.isEmpty) {
                    return const Center(
                      child: Text(
                        'Start a conversation',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, i) {
                      final m = messages[i];
                      return Align(
                        alignment:
                            m.isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: m.isUser ? Colors.teal[700] : Colors.grey[850],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: MarkdownMessage(
                            text: m.text,
                            isUser: m.isUser,
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('Error: $e')),
              ),
            ),
            if (_loading)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.teal[300]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Input field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !_loading && currentConvId != null,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Consumer(
                    builder: (context, ref, child) {
                      return IconButton(
                        onPressed: _loading || currentConvId == null ? null : () => _send(ref),
                        icon: const Icon(Icons.send),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewConversationDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Conversation'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: 'Conversation title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final title = titleController.text.trim().isEmpty
                  ? 'New Chat'
                  : titleController.text.trim();
              try {
                await ref.read(createConversationProvider(title).future);
                if (mounted) Navigator.pop(context);
                ref.invalidate(conversationsProvider);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

