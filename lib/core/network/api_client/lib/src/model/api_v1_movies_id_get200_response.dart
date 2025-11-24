//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/api_v1_movies_id_get200_response_data.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_movies_id_get200_response.g.dart';

/// ApiV1MoviesIdGet200Response
///
/// Properties:
/// * [success] 
/// * [data] 
@BuiltValue()
abstract class ApiV1MoviesIdGet200Response implements Built<ApiV1MoviesIdGet200Response, ApiV1MoviesIdGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool? get success;

  @BuiltValueField(wireName: r'data')
  ApiV1MoviesIdGet200ResponseData? get data;

  ApiV1MoviesIdGet200Response._();

  factory ApiV1MoviesIdGet200Response([void updates(ApiV1MoviesIdGet200ResponseBuilder b)]) = _$ApiV1MoviesIdGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1MoviesIdGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1MoviesIdGet200Response> get serializer => _$ApiV1MoviesIdGet200ResponseSerializer();
}

class _$ApiV1MoviesIdGet200ResponseSerializer implements PrimitiveSerializer<ApiV1MoviesIdGet200Response> {
  @override
  final Iterable<Type> types = const [ApiV1MoviesIdGet200Response, _$ApiV1MoviesIdGet200Response];

  @override
  final String wireName = r'ApiV1MoviesIdGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1MoviesIdGet200Response object, {
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
        specifiedType: const FullType(ApiV1MoviesIdGet200ResponseData),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1MoviesIdGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1MoviesIdGet200ResponseBuilder result,
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
            specifiedType: const FullType(ApiV1MoviesIdGet200ResponseData),
          ) as ApiV1MoviesIdGet200ResponseData;
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
  ApiV1MoviesIdGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1MoviesIdGet200ResponseBuilder();
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

