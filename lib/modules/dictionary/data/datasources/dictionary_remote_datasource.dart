import 'package:dio/dio.dart';
import 'package:machine_test_dictionary/core/network/api_endpoints.dart';
import 'package:machine_test_dictionary/core/network/dio_client.dart';
import 'package:machine_test_dictionary/modules/dictionary/data/models/word_details_model.dart';

abstract class DictionaryRemoteDataSource {
  Future<WordDetailsModel> getWordDetails(String word);
}

class DictionaryRemoteDataSourceImpl implements DictionaryRemoteDataSource {
  const DictionaryRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<WordDetailsModel> getWordDetails(String word) async {
    try {
      final response = await _dioClient.get(ApiEndpoints.searchWordPath(word));
      final data = response.data;

      if (data is List && data.isNotEmpty && data.first is Map<String, dynamic>) {
        return WordDetailsModel.fromJson(data.first as Map<String, dynamic>);
      }

      throw Exception('Word details not found.');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          final message = data['message'] ?? 'No definitions found.';
          throw Exception(message);
        }
      }
      rethrow;
    }
  }
}
