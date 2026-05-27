class OpenAIService {
  Future<String> getChatResponse(String prompt) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'SmartGPT says: ${prompt.isEmpty ? 'Hello! What can I help you with today?' : 'I received your message: "$prompt".'}';
  }
}
