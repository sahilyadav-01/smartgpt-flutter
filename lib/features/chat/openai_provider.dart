import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/openai_service.dart';

final openAIServiceProvider = Provider<OpenAIService>((ref) {
  return OpenAIService(
    model: 'gpt-3.5-turbo',
    baseUrl: 'https://api.openai.com/v1',
  );
});

final chatResponseProvider = FutureProvider.family<String, String>((ref, prompt) async {
  final service = ref.watch(openAIServiceProvider);
  final response = await service.getChatResponse(prompt);
  return response;
});
