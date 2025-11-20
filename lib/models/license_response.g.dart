// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'license_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LicenseResponse _$LicenseResponseFromJson(Map<String, dynamic> json) =>
    LicenseResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      token: json['token'] as String?,
      expiresAt: (json['expiresAt'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LicenseResponseToJson(LicenseResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'token': instance.token,
      'expiresAt': instance.expiresAt,
    };
