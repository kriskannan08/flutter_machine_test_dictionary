class Env {
  /// Read environment from build
  static const String _env = String.fromEnvironment('ENV', defaultValue: 'dev');

  /// Expose raw value
  static String get value => _env;

  /// Flags (similar to Swift Environment.isProduction)
  static bool get isDev => _env == 'dev';
  static bool get isProd => _env == 'prod';

  /// Base URL selection
  static String get baseUrl {
    if (isProd) {
      return "https://api.dictionaryapi.dev";
    }

    return "https://api.dictionaryapi.dev";
  }

  /// API Version
  static String get apiVersion {
    return "api/v2/";
  }
}
