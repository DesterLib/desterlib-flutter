//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
// External packages
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';


part 'api_v1_tvshows_id_get200_response_data_seasons_inner_episodes_inner.g.dart';

/// ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner
///
/// Properties:
/// * [id] 
/// * [episodeNumber] 
/// * [seasonNumber] 
/// * [title] 
/// * [overview] 
/// * [airDate] 
/// * [runtime] 
/// * [stillUrl] 
/// * [filePath] 
/// * [fileSize] 
/// * [seasonId] 
/// * [streamUrl] 
@BuiltValue()
abstract class ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner implements Built<ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner, ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'episodeNumber')
  int? get episodeNumber;

  @BuiltValueField(wireName: r'seasonNumber')
  int? get seasonNumber;

  @BuiltValueField(wireName: r'title')
  String? get title;

  @BuiltValueField(wireName: r'overview')
  String? get overview;

  @BuiltValueField(wireName: r'airDate')
  DateTime? get airDate;

  @BuiltValueField(wireName: r'runtime')
  int? get runtime;

  @BuiltValueField(wireName: r'stillUrl')
  String? get stillUrl;

  @BuiltValueField(wireName: r'filePath')
  String? get filePath;

  @BuiltValueField(wireName: r'fileSize')
  String? get fileSize;

  @BuiltValueField(wireName: r'seasonId')
  String? get seasonId;

  @BuiltValueField(wireName: r'streamUrl')
  String? get streamUrl;

  ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner._();

  factory ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner([void updates(ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInnerBuilder b)]) = _$ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner> get serializer => _$ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInnerSerializer();
}

class _$ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInnerSerializer implements PrimitiveSerializer<ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner> {
  @override
  final Iterable<Type> types = const [ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner, _$ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner];

  @override
  final String wireName = r'ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.episodeNumber != null) {
      yield r'episodeNumber';
      yield serializers.serialize(
        object.episodeNumber,
        specifiedType: const FullType(int),
      );
    }
    if (object.seasonNumber != null) {
      yield r'seasonNumber';
      yield serializers.serialize(
        object.seasonNumber,
        specifiedType: const FullType(int),
      );
    }
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
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
    if (object.runtime != null) {
      yield r'runtime';
      yield serializers.serialize(
        object.runtime,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.stillUrl != null) {
      yield r'stillUrl';
      yield serializers.serialize(
        object.stillUrl,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.filePath != null) {
      yield r'filePath';
      yield serializers.serialize(
        object.filePath,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.fileSize != null) {
      yield r'fileSize';
      yield serializers.serialize(
        object.fileSize,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.seasonId != null) {
      yield r'seasonId';
      yield serializers.serialize(
        object.seasonId,
        specifiedType: const FullType(String),
      );
    }
    if (object.streamUrl != null) {
      yield r'streamUrl';
      yield serializers.serialize(
        object.streamUrl,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInnerBuilder result,
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
        case r'episodeNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.episodeNumber = valueDes;
          break;
        case r'seasonNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.seasonNumber = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
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
        case r'runtime':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.runtime = valueDes;
          break;
        case r'stillUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.stillUrl = valueDes;
          break;
        case r'filePath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.filePath = valueDes;
          break;
        case r'fileSize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fileSize = valueDes;
          break;
        case r'seasonId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.seasonId = valueDes;
          break;
        case r'streamUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.streamUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInnerBuilder();
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

