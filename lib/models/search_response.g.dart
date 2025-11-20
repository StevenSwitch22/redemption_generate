// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResponse _$SearchResponseFromJson(Map<String, dynamic> json) =>
    SearchResponse(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>?)?.map((e) => e as String).toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$SearchResponseToJson(SearchResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'message': instance.message,
    };

CodeGenerateRequest _$CodeGenerateRequestFromJson(Map<String, dynamic> json) =>
    CodeGenerateRequest(
      keyword: json['keyword'] as String,
      token: json['token'] as String,
    );

Map<String, dynamic> _$CodeGenerateRequestToJson(
  CodeGenerateRequest instance,
) => <String, dynamic>{'keyword': instance.keyword, 'token': instance.token};

EncryptedData _$EncryptedDataFromJson(Map<String, dynamic> json) =>
    EncryptedData(
      i: json['i'] as String,
      r: (json['r'] as num).toInt(),
      e: json['e'] as String,
    );

Map<String, dynamic> _$EncryptedDataToJson(EncryptedData instance) =>
    <String, dynamic>{'i': instance.i, 'r': instance.r, 'e': instance.e};

CodeGenerateResponse _$CodeGenerateResponseFromJson(
  Map<String, dynamic> json,
) => CodeGenerateResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : CodeData.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
  newToken: json['newToken'] as String?,
  expiresAt: (json['expiresAt'] as num?)?.toInt(),
);

Map<String, dynamic> _$CodeGenerateResponseToJson(
  CodeGenerateResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
  'newToken': instance.newToken,
  'expiresAt': instance.expiresAt,
};

CodeData _$CodeDataFromJson(Map<String, dynamic> json) => CodeData(
  searchKey: json['search_key'] as String,
  codeType: json['code_type'] as String,
  encryptedData: EncryptedData.fromJson(
    json['encrypted_data'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$CodeDataToJson(CodeData instance) => <String, dynamic>{
  'search_key': instance.searchKey,
  'code_type': instance.codeType,
  'encrypted_data': instance.encryptedData,
};
