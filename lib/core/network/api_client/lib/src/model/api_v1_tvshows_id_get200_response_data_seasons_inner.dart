//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/api_v1_tvshows_id_get200_response_data_seasons_inner_episodes_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_tvshows_id_get200_response_data_seasons_inner.g.dart';

/// ApiV1TvshowsIdGet200ResponseDataSeasonsInner
///
/// Properties:
/// * [id] 
/// * [seasonNumber] 
/// * [name] 
/// * [overview] 
/// * [airDate] 
/// * [posterUrl] 
/// * [tvShowId] 
/// * [episodes] 
@BuiltValue()
abstract class ApiV1TvshowsIdGet200ResponseDataSeasonsInner implements Built<ApiV1TvshowsIdGet200ResponseDataSeasonsInner, ApiV1TvshowsIdGet200ResponseDataSeasonsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'seasonNumber')
  int? get seasonNumber;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'overview')
  String? get overview;

  @BuiltValueField(wireName: r'airDate')
  DateTime? get airDate;

  @BuiltValueField(wireName: r'posterUrl')
  String? get posterUrl;

  @BuiltValueField(wireName: r'tvShowId')
  String? get tvShowId;

  @BuiltValueField(wireName: r'episodes')
  BuiltList<ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner>? get episodes;

  ApiV1TvshowsIdGet200ResponseDataSeasonsInner._();

  factory ApiV1TvshowsIdGet200ResponseDataSeasonsInner([void updates(ApiV1TvshowsIdGet200ResponseDataSeasonsInnerBuilder b)]) = _$ApiV1TvshowsIdGet200ResponseDataSeasonsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1TvshowsIdGet200ResponseDataSeasonsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1TvshowsIdGet200ResponseDataSeasonsInner> get serializer => _$ApiV1TvshowsIdGet200ResponseDataSeasonsInnerSerializer();
}

class _$ApiV1TvshowsIdGet200ResponseDataSeasonsInnerSerializer implements PrimitiveSerializer<ApiV1TvshowsIdGet200ResponseDataSeasonsInner> {
  @override
  final Iterable<Type> types = const [ApiV1TvshowsIdGet200ResponseDataSeasonsInner, _$ApiV1TvshowsIdGet200ResponseDataSeasonsInner];

  @override
  final String wireName = r'ApiV1TvshowsIdGet200ResponseDataSeasonsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1TvshowsIdGet200ResponseDataSeasonsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.seasonNumber != null) {
      yield r'seasonNumber';
      yield serializers.serialize(
        object.seasonNumber,
        specifiedType: const FullType(int),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.overview != null) {
      yield r'overview';
      yield serializers.serialize(
        object.overview,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.airDate != null) {
      yield r'airDate';
      yield serializers.serialize(
        object.airDate,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.posterUrl != null) {
      yield r'posterUrl';
      yield serializers.serialize(
        object.posterUrl,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.tvShowId != null) {
      yield r'tvShowId';
      yield serializers.serialize(
        object.tvShowId,
        specifiedType: const FullType(String),
      );
    }
    if (object.episodes != null) {
      yield r'episodes';
      yield serializers.serialize(
        object.episodes,
        specifiedType: const FullType(BuiltList, [FullType(ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1TvshowsIdGet200ResponseDataSeasonsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1TvshowsIdGet200ResponseDataSeasonsInnerBuilder result,
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
        case r'seasonNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.seasonNumber = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'overview':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.overview = valueDes;
          break;
        case r'airDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.airDate = valueDes;
          break;
        case r'posterUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.posterUrl = valueDes;
          break;
        case r'tvShowId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tvShowId = valueDes;
          break;
        case r'episodes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner)]),
          ) as BuiltList<ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner>;
          result.episodes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1TvshowsIdGet200ResponseDataSeasonsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1TvshowsIdGet200ResponseDataSeasonsInnerBuilder();
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

