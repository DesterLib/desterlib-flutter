//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
// External packages
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:openapi/src/model/public_settings.dart';


part 'api_v1_settings_put200_response.g.dart';

/// ApiV1SettingsPut200Response
///
/// Properties:
/// * [success] 
/// * [message] 
/// * [data] 
@BuiltValue()
abstract class ApiV1SettingsPut200Response implements Built<ApiV1SettingsPut200Response, ApiV1SettingsPut200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool? get success;

  @BuiltValueField(wireName: r'message')
  String? get message;

  @BuiltValueField(wireName: r'data')
  PublicSettings? get data;

  ApiV1SettingsPut200Response._();

  factory ApiV1SettingsPut200Response([void updates(ApiV1SettingsPut200ResponseBuilder b)]) = _$ApiV1SettingsPut200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1SettingsPut200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1SettingsPut200Response> get serializer => _$ApiV1SettingsPut200ResponseSerializer();
}

class _$ApiV1SettingsPut200ResponseSerializer implements PrimitiveSerializer<ApiV1SettingsPut200Response> {
  @override
  final Iterable<Type> types = const [ApiV1SettingsPut200Response, _$ApiV1SettingsPut200Response];

  @override
  final String wireName = r'ApiV1SettingsPut200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1SettingsPut200Response object, {
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
    ApiV1SettingsPut200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1SettingsPut200ResponseBuilder result,
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
  ApiV1SettingsPut200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1SettingsPut200ResponseBuilder();
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

