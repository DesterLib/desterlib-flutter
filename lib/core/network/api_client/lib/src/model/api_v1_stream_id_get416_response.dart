//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
// External packages
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';


part 'api_v1_stream_id_get416_response.g.dart';

/// ApiV1StreamIdGet416Response
///
/// Properties:
/// * [error] 
/// * [message] 
@BuiltValue()
abstract class ApiV1StreamIdGet416Response implements Built<ApiV1StreamIdGet416Response, ApiV1StreamIdGet416ResponseBuilder> {
  @BuiltValueField(wireName: r'error')
  String? get error;

  @BuiltValueField(wireName: r'message')
  String? get message;

  ApiV1StreamIdGet416Response._();

  factory ApiV1StreamIdGet416Response([void updates(ApiV1StreamIdGet416ResponseBuilder b)]) = _$ApiV1StreamIdGet416Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1StreamIdGet416ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1StreamIdGet416Response> get serializer => _$ApiV1StreamIdGet416ResponseSerializer();
}

class _$ApiV1StreamIdGet416ResponseSerializer implements PrimitiveSerializer<ApiV1StreamIdGet416Response> {
  @override
  final Iterable<Type> types = const [ApiV1StreamIdGet416Response, _$ApiV1StreamIdGet416Response];

  @override
  final String wireName = r'ApiV1StreamIdGet416Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1StreamIdGet416Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.error != null) {
      yield r'error';
      yield serializers.serialize(
        object.error,
        specifiedType: const FullType(String),
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
    ApiV1StreamIdGet416Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1StreamIdGet416ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.error = valueDes;
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
  ApiV1StreamIdGet416Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1StreamIdGet416ResponseBuilder();
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

