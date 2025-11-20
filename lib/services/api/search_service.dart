import 'package:dio/dio.dart';
import '../../models/search_response.dart';
import 'api_client.dart';

class SearchService {
  final Dio _dio = ApiClient().dio;

  Future<SearchResponse> getSuggestions({
    required String keyword,
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        '/search/suggestions',
        data: {
          'keyword': keyword,
          'token': token,
        },
      );

      return SearchResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return SearchResponse.fromJson(e.response!.data);
      }
      rethrow;
    }
  }

  Future<CodeGenerateResponse> generateCode({
    required String keyword,
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        '/search',
        data: {
          'keyword': keyword,
          'token': token,
        },
      );

      return CodeGenerateResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return CodeGenerateResponse.fromJson(e.response!.data);
      }
      rethrow;
    }
  }
}
