import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import '../../config/constants.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late final Dio _dio;

  Dio get dio => _dio;

  void initialize({String? token}) {
    final options = BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    _dio = Dio(options);

    // 生产环境：使用系统默认的证书验证
    // 如果需要在 debug 模式下信任自签名证书，可以添加条件判断
    if (kDebugMode) {
      // 仅在 debug 模式下信任所有证书（方便开发调试）
      _dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback = (cert, host, port) => true;
          return client;
        },
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            print('📤 REQUEST: ${options.method} ${options.uri}');
            print('📦 DATA: ${options.data}');
            print('🔑 HEADERS: ${options.headers}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
            print('📦 DATA: ${response.data}');
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            print('❌ ERROR: ${error.type}');
            print('📍 URL: ${error.requestOptions.uri}');
            print('💬 MESSAGE: ${error.message}');
            print('🔍 ERROR DETAIL: ${error.error}');
            if (error.response != null) {
              print('📦 RESPONSE DATA: ${error.response!.data}');
              print('🔢 STATUS CODE: ${error.response!.statusCode}');
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  void updateToken(String? token) {
    _dio.options.headers['Authorization'] =
        token != null ? 'Bearer $token' : null;
  }
}
