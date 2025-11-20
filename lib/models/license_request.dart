import 'package:json_annotation/json_annotation.dart';

part 'license_request.g.dart';

@JsonSerializable()
class LicenseRequest {
  @JsonKey(name: 'license_key')
  final String licenseKey;

  @JsonKey(name: 'device_id')
  final String deviceId;

  LicenseRequest({
    required this.licenseKey,
    required this.deviceId,
  });

  factory LicenseRequest.fromJson(Map<String, dynamic> json) =>
      _$LicenseRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LicenseRequestToJson(this);
}
