import 'env.dart';

class ApiEndpoints {
  static String get baseUrl => Env.baseUrl;

  static const searchWord = "entries/en/<keyword>";

  static String searchWordPath(String keyword) {
    final encodedKeyword = Uri.encodeComponent(keyword.trim().toLowerCase());
    final endpoint = searchWord.replaceFirst('<keyword>', encodedKeyword);

    return '/${Env.apiVersion}$endpoint';
  }
}
