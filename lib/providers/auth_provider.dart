import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api/auth_service.dart';
import '../services/local/secure_storage.dart';
import '../utils/device_utils.dart';
import '../services/api/api_client.dart';

final authServiceProvider = Provider((ref) => AuthService());
final secureStorageProvider = Provider((ref) => SecureStorageService());

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? errorMessage;
  final String? token;

  AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.errorMessage,
    this.token,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? errorMessage,
    String? token,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      token: token ?? this.token,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final SecureStorageService _storage;

  AuthNotifier(this._authService, this._storage) : super(AuthState());

  Future<void> checkAuth() async {
    final token = await _storage.getToken();
    if (token != null && token.isNotEmpty) {
      ApiClient().initialize(token: token);
      state = state.copyWith(
        isAuthenticated: true,
        token: token,
      );
    } else {
      ApiClient().initialize();
      state = state.copyWith(isAuthenticated: false);
    }
  }

  Future<bool> login(String licenseKey) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      String? deviceId = await _storage.getDeviceId();
      if (deviceId == null) {
        deviceId = await DeviceUtils.generateDeviceId();
        await _storage.saveDeviceId(deviceId);
      }

      final response = await _authService.activate(
        licenseKey: licenseKey,
        deviceId: deviceId,
      );

      if (response.success && response.token != null) {
        await _storage.saveToken(response.token!);
        if (response.expiresAt != null) {
          await _storage.saveExpiresAt(response.expiresAt!);
        }

        ApiClient().updateToken(response.token);

        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
          token: response.token,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.message ?? '激活失败',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '发生错误: ${e.toString()}',
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.clearAll();
    ApiClient().updateToken(null);
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthNotifier(authService, storage);
});
