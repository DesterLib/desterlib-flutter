//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_logs_delete200_response.g.dart';

/// ApiV1LogsDelete200Response
///
/// Properties:
/// * [success] 
/// * [message] 
@BuiltValue()
abstract class ApiV1LogsDelete200Response implements Built<ApiV1LogsDelete200Response, ApiV1LogsDelete200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool? get success;

  @BuiltValueField(wireName: r'message')
  String? get message;

  ApiV1LogsDelete200Response._();

  factory ApiV1LogsDelete200Response([void updates(ApiV1LogsDelete200ResponseBuilder b)]) = _$ApiV1LogsDelete200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1LogsDelete200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1LogsDelete200Response> get serializer => _$ApiV1LogsDelete200ResponseSerializer();
}

class _$ApiV1LogsDelete200ResponseSerializer implements PrimitiveSerializer<ApiV1LogsDelete200Response> {
  @override
  final Iterable<Type> types = const [ApiV1LogsDelete200Response, _$ApiV1LogsDelete200Response];

  @override
  final String wireName = r'ApiV1LogsDelete200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1LogsDelete200Response object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1LogsDelete200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1LogsDelete200ResponseBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1LogsDelete200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1LogsDelete200ResponseBuilder();
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

