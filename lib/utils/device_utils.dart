import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DeviceUtils {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  
  static Future<String> generateDeviceId() async {
    try {
      String identifier = '';
      
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        final androidId = androidInfo.id;
        final brand = androidInfo.brand;
        final model = androidInfo.model;
        identifier = '$androidId-$brand-$model';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        final iosId = iosInfo.identifierForVendor ?? '';
        final model = iosInfo.model;
        final name = iosInfo.name;
        identifier = '$iosId-$name-$model';
      } else {
        identifier = 'web-${DateTime.now().millisecondsSinceEpoch}';
      }
      
      final bytes = utf8.encode(identifier);
      final digest = sha256.convert(bytes);
      final deviceId = digest.toString().substring(0, 32);
      
      return deviceId;
    } catch (e) {
      final fallback = 'fallback-${DateTime.now().millisecondsSinceEpoch}';
      final bytes = utf8.encode(fallback);
      final digest = sha256.convert(bytes);
      return digest.toString().substring(0, 32);
    }
  }
}
