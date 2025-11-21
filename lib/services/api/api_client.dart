import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';
import '../../config/constants.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late final Dio _dio;
  bool _isInitialized = false;

  Dio get dio => _dio;

  Future<void> initialize({String? token}) async {
    if (!_isInitialized) {
      final options = BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout:
            const Duration(milliseconds: AppConstants.connectTimeout),
        receiveTimeout:
            const Duration(milliseconds: AppConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      _dio = Dio(options);
      await _configureCustomCertificate();

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
              print(
                  '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
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

      _isInitialized = true;
    }

    _dio.options.headers['Authorization'] =
        token != null && token.isNotEmpty ? 'Bearer $token' : null;
  }

  Future<void> _configureCustomCertificate() async {
    final sslCert = await rootBundle.load('assets/certificates/self.crt');
    final securityContext = SecurityContext(withTrustedRoots: false)
      ..setTrustedCertificatesBytes(sslCert.buffer.asUint8List());

    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () => HttpClient(context: securityContext),
    );
  }

  void updateToken(String? token) {
    _dio.options.headers['Authorization'] =
        token != null && token.isNotEmpty ? 'Bearer $token' : null;
  }
}
