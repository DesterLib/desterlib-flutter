//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/public_settings.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_settings_get200_response.g.dart';

/// ApiV1SettingsGet200Response
///
/// Properties:
/// * [success] 
/// * [data] 
@BuiltValue()
abstract class ApiV1SettingsGet200Response implements Built<ApiV1SettingsGet200Response, ApiV1SettingsGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool? get success;

  @BuiltValueField(wireName: r'data')
  PublicSettings? get data;

  ApiV1SettingsGet200Response._();

  factory ApiV1SettingsGet200Response([void updates(ApiV1SettingsGet200ResponseBuilder b)]) = _$ApiV1SettingsGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1SettingsGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1SettingsGet200Response> get serializer => _$ApiV1SettingsGet200ResponseSerializer();
}

class _$ApiV1SettingsGet200ResponseSerializer implements PrimitiveSerializer<ApiV1SettingsGet200Response> {
  @override
  final Iterable<Type> types = const [ApiV1SettingsGet200Response, _$ApiV1SettingsGet200Response];

  @override
  final String wireName = r'ApiV1SettingsGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1SettingsGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.success != null) {
      yield r'success';
      yield serializers.serialize(
        object.success,
        specifiedType: const FullType(bool),
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
    ApiV1SettingsGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1SettingsGet200ResponseBuilder result,
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
  ApiV1SettingsGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1SettingsGet200ResponseBuilder();
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

