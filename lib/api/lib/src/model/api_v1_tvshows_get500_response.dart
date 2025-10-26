//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_tvshows_get500_response.g.dart';

/// ApiV1TvshowsGet500Response
///
/// Properties:
/// * [error] 
/// * [message] 
@BuiltValue()
abstract class ApiV1TvshowsGet500Response implements Built<ApiV1TvshowsGet500Response, ApiV1TvshowsGet500ResponseBuilder> {
  @BuiltValueField(wireName: r'error')
  String? get error;

  @BuiltValueField(wireName: r'message')
  String? get message;

  ApiV1TvshowsGet500Response._();

  factory ApiV1TvshowsGet500Response([void updates(ApiV1TvshowsGet500ResponseBuilder b)]) = _$ApiV1TvshowsGet500Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1TvshowsGet500ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1TvshowsGet500Response> get serializer => _$ApiV1TvshowsGet500ResponseSerializer();
}

class _$ApiV1TvshowsGet500ResponseSerializer implements PrimitiveSerializer<ApiV1TvshowsGet500Response> {
  @override
  final Iterable<Type> types = const [ApiV1TvshowsGet500Response, _$ApiV1TvshowsGet500Response];

  @override
  final String wireName = r'ApiV1TvshowsGet500Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1TvshowsGet500Response object, {
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
    ApiV1TvshowsGet500Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1TvshowsGet500ResponseBuilder result,
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
  ApiV1TvshowsGet500Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1TvshowsGet500ResponseBuilder();
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

