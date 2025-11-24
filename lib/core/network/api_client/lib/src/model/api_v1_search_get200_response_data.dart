//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/api_v1_search_get200_response_data_movies_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/api_v1_search_get200_response_data_tv_shows_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_search_get200_response_data.g.dart';

/// ApiV1SearchGet200ResponseData
///
/// Properties:
/// * [movies] 
/// * [tvShows] 
@BuiltValue()
abstract class ApiV1SearchGet200ResponseData implements Built<ApiV1SearchGet200ResponseData, ApiV1SearchGet200ResponseDataBuilder> {
  @BuiltValueField(wireName: r'movies')
  BuiltList<ApiV1SearchGet200ResponseDataMoviesInner>? get movies;

  @BuiltValueField(wireName: r'tvShows')
  BuiltList<ApiV1SearchGet200ResponseDataTvShowsInner>? get tvShows;

  ApiV1SearchGet200ResponseData._();

  factory ApiV1SearchGet200ResponseData([void updates(ApiV1SearchGet200ResponseDataBuilder b)]) = _$ApiV1SearchGet200ResponseData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1SearchGet200ResponseDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1SearchGet200ResponseData> get serializer => _$ApiV1SearchGet200ResponseDataSerializer();
}

class _$ApiV1SearchGet200ResponseDataSerializer implements PrimitiveSerializer<ApiV1SearchGet200ResponseData> {
  @override
  final Iterable<Type> types = const [ApiV1SearchGet200ResponseData, _$ApiV1SearchGet200ResponseData];

  @override
  final String wireName = r'ApiV1SearchGet200ResponseData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1SearchGet200ResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.movies != null) {
      yield r'movies';
      yield serializers.serialize(
        object.movies,
        specifiedType: const FullType(BuiltList, [FullType(ApiV1SearchGet200ResponseDataMoviesInner)]),
      );
    }
    if (object.tvShows != null) {
      yield r'tvShows';
      yield serializers.serialize(
        object.tvShows,
        specifiedType: const FullType(BuiltList, [FullType(ApiV1SearchGet200ResponseDataTvShowsInner)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1SearchGet200ResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1SearchGet200ResponseDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'movies':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ApiV1SearchGet200ResponseDataMoviesInner)]),
          ) as BuiltList<ApiV1SearchGet200ResponseDataMoviesInner>;
          result.movies.replace(valueDes);
          break;
        case r'tvShows':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ApiV1SearchGet200ResponseDataTvShowsInner)]),
          ) as BuiltList<ApiV1SearchGet200ResponseDataTvShowsInner>;
          result.tvShows.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1SearchGet200ResponseData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1SearchGet200ResponseDataBuilder();
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

