import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/secrets.dart';

class OpenAIService {
  OpenAIService({
    String model = 'gpt-3.5-turbo',
    String baseUrl = 'https://api.openai.com/v1',
  })  : _model = model,
        _baseUrl = baseUrl;

  final String _model;
  final String _baseUrl;

  Future<String> getChatResponse(String prompt) async {
    if (prompt.trim().isEmpty) {
      return 'Hello! What can I help you with today?';
    }

    final apiKey = Secrets.openAIApiKey;
    if (apiKey.isEmpty || apiKey == 'YOUR_OPENAI_API_KEY') {
      return 'Missing OpenAI API key. Set OPENAI_API_KEY via --dart-define or build-time env.';
    }

    final uri = Uri.parse('$_baseUrl/chat/completions');

    final res = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': _model,
        'temperature': 0.7,
        'messages': [
          {
            'role': 'user',
            'content': prompt,
          },
        ],
      }),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      if (kDebugMode) {
        debugPrint('OpenAI error ${res.statusCode}: ${res.body}');
      }
      throw Exception('OpenAI request failed: ${res.statusCode}');
    }

    final decoded = jsonDecode(res.body) as Map<String, dynamic>;
    final choices = decoded['choices'] as List<dynamic>?;
    final message = choices?.isNotEmpty == true
        ? (choices!.first as Map<String, dynamic>)['message']
        : null;
    final content = message is Map<String, dynamic> ? message['content'] : null;

    return (content as String?)?.trim() ?? '';
  }
}

