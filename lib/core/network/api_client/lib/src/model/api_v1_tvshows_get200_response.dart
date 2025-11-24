//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/api_v1_tvshows_get200_response_data_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_tvshows_get200_response.g.dart';

/// ApiV1TvshowsGet200Response
///
/// Properties:
/// * [success] 
/// * [data] 
@BuiltValue()
abstract class ApiV1TvshowsGet200Response implements Built<ApiV1TvshowsGet200Response, ApiV1TvshowsGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool? get success;

  @BuiltValueField(wireName: r'data')
  BuiltList<ApiV1TvshowsGet200ResponseDataInner>? get data;

  ApiV1TvshowsGet200Response._();

  factory ApiV1TvshowsGet200Response([void updates(ApiV1TvshowsGet200ResponseBuilder b)]) = _$ApiV1TvshowsGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1TvshowsGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1TvshowsGet200Response> get serializer => _$ApiV1TvshowsGet200ResponseSerializer();
}

class _$ApiV1TvshowsGet200ResponseSerializer implements PrimitiveSerializer<ApiV1TvshowsGet200Response> {
  @override
  final Iterable<Type> types = const [ApiV1TvshowsGet200Response, _$ApiV1TvshowsGet200Response];

  @override
  final String wireName = r'ApiV1TvshowsGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1TvshowsGet200Response object, {
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
        specifiedType: const FullType(BuiltList, [FullType(ApiV1TvshowsGet200ResponseDataInner)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1TvshowsGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1TvshowsGet200ResponseBuilder result,
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
            specifiedType: const FullType(BuiltList, [FullType(ApiV1TvshowsGet200ResponseDataInner)]),
          ) as BuiltList<ApiV1TvshowsGet200ResponseDataInner>;
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
  ApiV1TvshowsGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1TvshowsGet200ResponseBuilder();
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

