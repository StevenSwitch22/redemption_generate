# 网络连接问题修复总结

## 问题描述
应用在使用卡密登录时显示"网络连接失败，请检查网络设置"或"网络错误：未知错误"。

## 根本原因分析

### 1. 缺少网络权限 ✅ 已修复
**问题**: `AndroidManifest.xml` 缺少必要的网络权限声明
**解决**: 添加了以下权限：
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### 2. SSL 证书验证失败 ✅ 已修复
**问题**: API 地址使用 IP + HTTPS (`https://47.104.12.235`)，导致 SSL 证书验证失败
**现象**: 日志显示 `DioExceptionType.unknown`，MESSAGE 为 null

**解决方案**:
1. **配置网络安全策略** (`network_security_config.xml`):
   - 允许明文流量
   - 信任系统和用户安装的证书
   - 针对特定 IP 的配置

2. **Dio 客户端配置** (使用 Dio 5.x API):
   ```dart
   _dio.httpClientAdapter = IOHttpClientAdapter(
     createHttpClient: () {
       final client = HttpClient();
       client.badCertificateCallback = (cert, host, port) => true;
       return client;
     },
   );
   ```

### 3. 改进的错误处理 ✅ 已添加
- 详细的错误类型判断
- 针对不同 `DioExceptionType` 的中文提示
- 调试日志增强（包括 `error.error` 详情）

## 修改的文件

### 1. `android/app/src/main/AndroidManifest.xml`
```xml
<!-- 添加网络权限 -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

<!-- 配置网络安全策略 -->
<application
    android:networkSecurityConfig="@xml/network_security_config"
    android:usesCleartextTraffic="true"
    ...>
```

### 2. `android/app/src/main/res/xml/network_security_config.xml` (新建)
```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="true">
        <trust-anchors>
            <certificates src="system" />
            <certificates src="user" />
        </trust-anchors>
    </base-config>
    
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">47.104.12.235</domain>
        <trust-anchors>
            <certificates src="system" />
            <certificates src="user" />
        </trust-anchors>
    </domain-config>
</network-security-config>
```

### 3. `lib/services/api/api_client.dart`
- ✅ 导入 `package:dio/io.dart` (Dio 5.x)
- ✅ 配置 `IOHttpClientAdapter` 信任所有证书
- ✅ 增强调试日志（打印 `error.error`）

### 4. `lib/services/api/auth_service.dart`
- ✅ 改进错误类型判断
- ✅ 添加 `DioExceptionType.unknown` 的处理
- ✅ 提供更详细的中文错误提示

## 调试日志示例

### 正常请求日志
```
📤 REQUEST: POST https://47.104.12.235/api/activate
📦 DATA: {license_key: XXXX-XXXX-XXXX-XXXX, device_id: xxxx}
🔑 HEADERS: {Content-Type: application/json}
✅ RESPONSE: 200 https://47.104.12.235/api/activate
📦 DATA: {success: true, token: xxx, ...}
```

### 错误日志（修复前）
```
❌ ERROR: DioExceptionType.unknown
📍 URL: https://47.104.12.235/api/activate
💬 MESSAGE: null
🔍 ERROR DETAIL: HandshakeException: ...
```

### 错误日志（修复后 - 如果服务器不可达）
```
❌ ERROR: DioExceptionType.connectionError
📍 URL: https://47.104.12.235/api/activate
💬 MESSAGE: Connection refused
🔍 ERROR DETAIL: SocketException: ...
```

## 后续建议

### 生产环境配置
当前配置**信任所有证书**，仅适用于开发和测试。生产环境建议：

1. **使用域名** 而不是 IP 地址
2. **配置有效的 SSL 证书**（Let's Encrypt 等）
3. **移除** `badCertificateCallback = true`
4. **限制** `network_security_config.xml` 的信任范围

### API 地址配置
如果需要修改 API 地址，编辑：
```dart
// lib/config/constants.dart
static const String apiBaseUrl = 'https://your-domain.com/api';
```

### 测试步骤
1. 重新构建 APK: `flutter build apk --release`
2. 安装到设备: `adb install -r build/app/outputs/flutter-apk/app-release.apk`
3. 打开应用，输入卡密测试
4. 查看日志: `adb logcat | findstr flutter`

## 常见错误对照表

| 错误类型 | 可能原因 | 解决方案 |
|---------|---------|---------|
| `连接超时` | 网络慢、服务器无响应 | 检查网络、增加超时时间 |
| `SSL证书验证失败` | 证书问题 | 已通过配置解决 |
| `网络连接失败` | 服务器不可达、IP/端口错误 | 检查 API 地址配置 |
| `服务器返回错误: 401` | 未授权、Token 无效 | 检查卡密或 Token |
| `服务器返回错误: 500` | 服务器内部错误 | 联系后端开发者 |

---
**修复完成时间**: 2025-11-20  
**修复内容**: 网络权限 + SSL 证书配置 + 错误处理改进
