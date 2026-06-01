import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_message.dart';

class ChatHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  /// Save a message to Firestore
  Future<void> saveMessage(ChatMessage message) async {
    if (_userId.isEmpty) throw Exception('User not authenticated');
    
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('conversations')
        .doc(message.conversationId)
        .collection('messages')
        .doc(message.id)
        .set(message.toFirestore());
  }

  /// Get all messages for a conversation
  Future<List<ChatMessage>> getConversationMessages(String conversationId) async {
    if (_userId.isEmpty) throw Exception('User not authenticated');
    
    final snapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .get();

    return snapshot.docs
        .map((doc) => ChatMessage.fromFirestore(doc.data()))
        .toList();
  }

  /// Stream messages for a conversation
  Stream<List<ChatMessage>> streamConversationMessages(String conversationId) {
    if (_userId.isEmpty) {
      return Stream.error('User not authenticated');
    }
    
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromFirestore(doc.data()))
            .toList());
  }

  /// Create or get current conversation
  Future<String> createConversation(String title) async {
    if (_userId.isEmpty) throw Exception('User not authenticated');
    
    final conversation = Conversation(
      userId: _userId,
      title: title,
    );

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('conversations')
        .doc(conversation.id)
        .set(conversation.toFirestore());

    return conversation.id;
  }

  /// Get all conversations for user
  Future<List<Conversation>> getConversations() async {
    if (_userId.isEmpty) throw Exception('User not authenticated');
    
    final snapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('conversations')
        .orderBy('updatedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Conversation.fromFirestore(doc.data()))
        .toList();
  }

  /// Delete a conversation
  Future<void> deleteConversation(String conversationId) async {
    if (_userId.isEmpty) throw Exception('User not authenticated');
    
    // Delete all messages first
    final messagesSnapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .get();

    for (final doc in messagesSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete conversation
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('conversations')
        .doc(conversationId)
        .delete();
  }

  /// Update conversation title
  Future<void> updateConversationTitle(
      String conversationId, String newTitle) async {
    if (_userId.isEmpty) throw Exception('User not authenticated');
    
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('conversations')
        .doc(conversationId)
        .update({'title': newTitle, 'updatedAt': DateTime.now().toIso8601String()});
  }
}
