import 'package:json_annotation/json_annotation.dart';

part 'search_response.g.dart';

@JsonSerializable()
class SearchResponse {
  final bool success;
  final List<String>? data;
  final String? message;

  SearchResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseToJson(this);
}

@JsonSerializable()
class CodeGenerateRequest {
  final String keyword;
  final String token;

  CodeGenerateRequest({
    required this.keyword,
    required this.token,
  });

  factory CodeGenerateRequest.fromJson(Map<String, dynamic> json) =>
      _$CodeGenerateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CodeGenerateRequestToJson(this);
}

@JsonSerializable()
class EncryptedData {
  final String i;
  final int r;
  final String e;

  EncryptedData({
    required this.i,
    required this.r,
    required this.e,
  });

  factory EncryptedData.fromJson(Map<String, dynamic> json) =>
      _$EncryptedDataFromJson(json);

  Map<String, dynamic> toJson() => _$EncryptedDataToJson(this);
}

@JsonSerializable()
class CodeGenerateResponse {
  final bool success;
  final CodeData? data;
  final String? message;
  final String? newToken;
  final int? expiresAt;

  CodeGenerateResponse({
    required this.success,
    this.data,
    this.message,
    this.newToken,
    this.expiresAt,
  });

  factory CodeGenerateResponse.fromJson(Map<String, dynamic> json) =>
      _$CodeGenerateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CodeGenerateResponseToJson(this);
}

@JsonSerializable()
class CodeData {
  @JsonKey(name: 'search_key')
  final String searchKey;
  @JsonKey(name: 'code_type')
  final String codeType;
  @JsonKey(name: 'encrypted_data')
  final EncryptedData encryptedData;

  CodeData({
    required this.searchKey,
    required this.codeType,
    required this.encryptedData,
  });

  factory CodeData.fromJson(Map<String, dynamic> json) =>
      _$CodeDataFromJson(json);

  Map<String, dynamic> toJson() => _$CodeDataToJson(this);
}
