/// Compile-time and app-wide settings.
///
/// Override API base with: `--dart-define=API_BASE_URL=https://your.api`
class AppConfig {
  const AppConfig();

  String get apiBaseUrl => const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://jsonplaceholder.typicode.com',
  );

  Duration get connectTimeout => const Duration(seconds: 30);

  Duration get receiveTimeout => const Duration(seconds: 30);
}
