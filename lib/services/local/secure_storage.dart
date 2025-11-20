import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../config/constants.dart';

class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  Future<void> saveToken(String token) async {
    await _storage.write(key: AppConstants.tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: AppConstants.tokenKey);
  }

  Future<void> saveDeviceId(String deviceId) async {
    await _storage.write(key: AppConstants.deviceIdKey, value: deviceId);
  }

  Future<String?> getDeviceId() async {
    return await _storage.read(key: AppConstants.deviceIdKey);
  }

  Future<void> saveExpiresAt(int expiresAt) async {
    await _storage.write(
      key: AppConstants.expiresAtKey,
      value: expiresAt.toString(),
    );
  }

  Future<int?> getExpiresAt() async {
    final value = await _storage.read(key: AppConstants.expiresAtKey);
    return value != null ? int.tryParse(value) : null;
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
