class EnvConfig {
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://pixabay.com/api/',
  );
  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '',
  );
  static const bool isProd = bool.fromEnvironment(
    'IS_PROD',
    defaultValue: false,
  );

  static void validate() {
    if (apiKey.isEmpty) {
      throw Exception('API_KEY is not set. Please check your .env file.');
    }
  }
}
