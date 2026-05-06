import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test_dictionary/core/network/api_endpoints.dart';
import 'package:machine_test_dictionary/core/network/dio_client.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(ApiEndpoints.baseUrl);
});
