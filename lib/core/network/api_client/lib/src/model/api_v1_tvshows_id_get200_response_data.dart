//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
// External packages
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:openapi/src/model/api_v1_search_get200_response_data_tv_shows_inner_media.dart';
import 'package:openapi/src/model/api_v1_tvshows_id_get200_response_data_seasons_inner.dart';


part 'api_v1_tvshows_id_get200_response_data.g.dart';

/// ApiV1TvshowsIdGet200ResponseData
///
/// Properties:
/// * [id] 
/// * [creator] - Creator of the TV show
/// * [network] - Network that aired the TV show
/// * [mediaId] 
/// * [media] 
/// * [seasons] 
@BuiltValue()
abstract class ApiV1TvshowsIdGet200ResponseData implements Built<ApiV1TvshowsIdGet200ResponseData, ApiV1TvshowsIdGet200ResponseDataBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  /// Creator of the TV show
  @BuiltValueField(wireName: r'creator')
  String? get creator;

  /// Network that aired the TV show
  @BuiltValueField(wireName: r'network')
  String? get network;

  @BuiltValueField(wireName: r'mediaId')
  String? get mediaId;

  @BuiltValueField(wireName: r'media')
  ApiV1SearchGet200ResponseDataTvShowsInnerMedia? get media;

  @BuiltValueField(wireName: r'seasons')
  BuiltList<ApiV1TvshowsIdGet200ResponseDataSeasonsInner>? get seasons;

  ApiV1TvshowsIdGet200ResponseData._();

  factory ApiV1TvshowsIdGet200ResponseData([void updates(ApiV1TvshowsIdGet200ResponseDataBuilder b)]) = _$ApiV1TvshowsIdGet200ResponseData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1TvshowsIdGet200ResponseDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1TvshowsIdGet200ResponseData> get serializer => _$ApiV1TvshowsIdGet200ResponseDataSerializer();
}

class _$ApiV1TvshowsIdGet200ResponseDataSerializer implements PrimitiveSerializer<ApiV1TvshowsIdGet200ResponseData> {
  @override
  final Iterable<Type> types = const [ApiV1TvshowsIdGet200ResponseData, _$ApiV1TvshowsIdGet200ResponseData];

  @override
  final String wireName = r'ApiV1TvshowsIdGet200ResponseData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1TvshowsIdGet200ResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.creator != null) {
      yield r'creator';
      yield serializers.serialize(
        object.creator,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.network != null) {
      yield r'network';
      yield serializers.serialize(
        object.network,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.mediaId != null) {
      yield r'mediaId';
      yield serializers.serialize(
        object.mediaId,
        specifiedType: const FullType(String),
      );
    }
    if (object.media != null) {
      yield r'media';
      yield serializers.serialize(
        object.media,
        specifiedType: const FullType(ApiV1SearchGet200ResponseDataTvShowsInnerMedia),
      );
    }
    if (object.seasons != null) {
      yield r'seasons';
      yield serializers.serialize(
        object.seasons,
        specifiedType: const FullType(BuiltList, [FullType(ApiV1TvshowsIdGet200ResponseDataSeasonsInner)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1TvshowsIdGet200ResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1TvshowsIdGet200ResponseDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'creator':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.creator = valueDes;
          break;
        case r'network':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.network = valueDes;
          break;
        case r'mediaId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mediaId = valueDes;
          break;
        case r'media':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1SearchGet200ResponseDataTvShowsInnerMedia),
          ) as ApiV1SearchGet200ResponseDataTvShowsInnerMedia;
          result.media.replace(valueDes);
          break;
        case r'seasons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ApiV1TvshowsIdGet200ResponseDataSeasonsInner)]),
          ) as BuiltList<ApiV1TvshowsIdGet200ResponseDataSeasonsInner>;
          result.seasons.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1TvshowsIdGet200ResponseData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1TvshowsIdGet200ResponseDataBuilder();
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

