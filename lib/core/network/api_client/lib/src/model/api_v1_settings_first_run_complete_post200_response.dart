//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
// External packages
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';


part 'api_v1_settings_first_run_complete_post200_response.g.dart';

/// ApiV1SettingsFirstRunCompletePost200Response
///
/// Properties:
/// * [success] 
/// * [message] 
/// * [data] 
@BuiltValue()
abstract class ApiV1SettingsFirstRunCompletePost200Response implements Built<ApiV1SettingsFirstRunCompletePost200Response, ApiV1SettingsFirstRunCompletePost200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool? get success;

  @BuiltValueField(wireName: r'message')
  String? get message;

  @BuiltValueField(wireName: r'data')
  JsonObject? get data;

  ApiV1SettingsFirstRunCompletePost200Response._();

  factory ApiV1SettingsFirstRunCompletePost200Response([void updates(ApiV1SettingsFirstRunCompletePost200ResponseBuilder b)]) = _$ApiV1SettingsFirstRunCompletePost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1SettingsFirstRunCompletePost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1SettingsFirstRunCompletePost200Response> get serializer => _$ApiV1SettingsFirstRunCompletePost200ResponseSerializer();
}

class _$ApiV1SettingsFirstRunCompletePost200ResponseSerializer implements PrimitiveSerializer<ApiV1SettingsFirstRunCompletePost200Response> {
  @override
  final Iterable<Type> types = const [ApiV1SettingsFirstRunCompletePost200Response, _$ApiV1SettingsFirstRunCompletePost200Response];

  @override
  final String wireName = r'ApiV1SettingsFirstRunCompletePost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1SettingsFirstRunCompletePost200Response object, {
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
        specifiedType: const FullType.nullable(JsonObject),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1SettingsFirstRunCompletePost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1SettingsFirstRunCompletePost200ResponseBuilder result,
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
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.data = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1SettingsFirstRunCompletePost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1SettingsFirstRunCompletePost200ResponseBuilder();
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

