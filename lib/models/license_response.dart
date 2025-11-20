import 'package:json_annotation/json_annotation.dart';

part 'license_response.g.dart';

@JsonSerializable()
class LicenseResponse {
  final bool success;
  final String? message;
  final String? token;

  @JsonKey(name: 'expiresAt')
  final int? expiresAt;

  LicenseResponse({
    required this.success,
    this.message,
    this.token,
    this.expiresAt,
  });

  factory LicenseResponse.fromJson(Map<String, dynamic> json) =>
      _$LicenseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LicenseResponseToJson(this);
}
