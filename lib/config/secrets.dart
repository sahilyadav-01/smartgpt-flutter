class Secrets {
  /// SECURITY WARNING:
  /// Do NOT ship real API keys in mobile apps.
  /// This is a temporary solution for local testing only.
  ///
  /// Recommended next step: move this to a backend proxy (Cloud Functions / server).
  static const String openAIApiKey = String.fromEnvironment('OPENAI_API_KEY');
}

