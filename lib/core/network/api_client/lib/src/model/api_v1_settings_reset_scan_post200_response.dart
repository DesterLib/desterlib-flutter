//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/public_settings.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_settings_reset_scan_post200_response.g.dart';

/// ApiV1SettingsResetScanPost200Response
///
/// Properties:
/// * [success] 
/// * [message] 
/// * [data] 
@BuiltValue()
abstract class ApiV1SettingsResetScanPost200Response implements Built<ApiV1SettingsResetScanPost200Response, ApiV1SettingsResetScanPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool? get success;

  @BuiltValueField(wireName: r'message')
  String? get message;

  @BuiltValueField(wireName: r'data')
  PublicSettings? get data;

  ApiV1SettingsResetScanPost200Response._();

  factory ApiV1SettingsResetScanPost200Response([void updates(ApiV1SettingsResetScanPost200ResponseBuilder b)]) = _$ApiV1SettingsResetScanPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1SettingsResetScanPost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1SettingsResetScanPost200Response> get serializer => _$ApiV1SettingsResetScanPost200ResponseSerializer();
}

class _$ApiV1SettingsResetScanPost200ResponseSerializer implements PrimitiveSerializer<ApiV1SettingsResetScanPost200Response> {
  @override
  final Iterable<Type> types = const [ApiV1SettingsResetScanPost200Response, _$ApiV1SettingsResetScanPost200Response];

  @override
  final String wireName = r'ApiV1SettingsResetScanPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1SettingsResetScanPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.success != null) {
      yield r'success';
      yield serializers.serialize(
        object.success,
        specifiedType: const FullType(bool),
      );
    }
    if (object.message != null) {
      yield r'message';
      yield serializers.serialize(
        object.message,
        specifiedType: const FullType(String),
      );
    }
    if (object.data != null) {
      yield r'data';
      yield serializers.serialize(
        object.data,
        specifiedType: const FullType(PublicSettings),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1SettingsResetScanPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1SettingsResetScanPost200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'success':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.success = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicSettings),
          ) as PublicSettings;
          result.data.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1SettingsResetScanPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1SettingsResetScanPost200ResponseBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

