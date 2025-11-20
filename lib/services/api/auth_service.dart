import 'package:dio/dio.dart';
import '../../models/license_request.dart';
import '../../models/license_response.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<LicenseResponse> activate({
    required String licenseKey,
    required String deviceId,
  }) async {
    try {
      final request = LicenseRequest(
        licenseKey: licenseKey,
        deviceId: deviceId,
      );

      final response = await _apiClient.dio.post(
        '/activate',
        data: request.toJson(),
      );

      return LicenseResponse.fromJson(response.data);
    } on DioException catch (e) {
      String errorMessage;
      
      if (e.response != null) {
        // 服务器返回了响应（状态码不是 2xx）
        try {
          return LicenseResponse.fromJson(e.response!.data);
        } catch (_) {
          errorMessage = '服务器返回错误: ${e.response!.statusCode}';
        }
      } else {
        // 网络层面的错误
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            errorMessage = '连接超时，请检查网络';
            break;
          case DioExceptionType.sendTimeout:
            errorMessage = '请求超时，请检查网络';
            break;
          case DioExceptionType.receiveTimeout:
            errorMessage = '响应超时，请检查网络';
            break;
          case DioExceptionType.badCertificate:
            errorMessage = 'SSL证书验证失败';
            break;
          case DioExceptionType.connectionError:
            errorMessage = '网络连接失败，请检查网络设置或服务器地址';
            break;
          case DioExceptionType.cancel:
            errorMessage = '请求已取消';
            break;
          case DioExceptionType.unknown:
            // 未知错误，通常是 SSL 或底层网络问题
            if (e.error != null) {
              errorMessage = '网络错误: ${e.error.toString()}';
            } else {
              errorMessage = '网络连接失败，请检查服务器地址是否正确';
            }
            break;
          default:
            errorMessage = '网络错误: ${e.message ?? "未知错误"}';
        }
      }
      
      return LicenseResponse(
        success: false,
        message: errorMessage,
      );
    } catch (e) {
      return LicenseResponse(
        success: false,
        message: '发生未知错误: ${e.toString()}',
      );
    }
  }
}
