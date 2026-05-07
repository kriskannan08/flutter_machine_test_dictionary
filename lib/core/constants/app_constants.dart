class AppConstants {
  static const String databaseName = 'offline_dictionary.db';
  static const String searchHistoryDatabaseName = 'dictionary.db';
  static const String wordListUrl = 'https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english.txt';
  static const String seedJsonPath = 'assets/database/dictionary_seed.json';
  
  static const Set<String> commonShortWords = {
    'a', 'i', 'an', 'to', 'at', 'by', 'do', 'go', 'if', 'in', 'is', 'it', 
    'me', 'my', 'no', 'of', 'on', 'or', 'so', 'up', 'us', 'we', 'am', 'as', 'be', 'he'
  };

  static const List<String> nonsenseWords = ['aaa', 'bbb', 'ccc', 'abc'];
}
