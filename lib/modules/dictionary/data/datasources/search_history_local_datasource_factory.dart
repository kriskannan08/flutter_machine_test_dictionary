import 'package:machine_test_dictionary/modules/dictionary/data/datasources/search_history_local_datasource.dart';
import 'package:machine_test_dictionary/modules/dictionary/data/datasources/search_history_local_datasource_stub.dart'
    if (dart.library.io) 'package:machine_test_dictionary/modules/dictionary/data/datasources/search_history_sqflite_local_datasource.dart'
    if (dart.library.html) 'package:machine_test_dictionary/modules/dictionary/data/datasources/search_history_web_local_datasource.dart';

SearchHistoryLocalDataSource createSearchHistoryLocalDataSource() {
  return createPlatformSearchHistoryLocalDataSource();
}
