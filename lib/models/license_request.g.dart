// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'license_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LicenseRequest _$LicenseRequestFromJson(Map<String, dynamic> json) =>
    LicenseRequest(
      licenseKey: json['license_key'] as String,
      deviceId: json['device_id'] as String,
    );

Map<String, dynamic> _$LicenseRequestToJson(LicenseRequest instance) =>
    <String, dynamic>{
      'license_key': instance.licenseKey,
      'device_id': instance.deviceId,
    };
