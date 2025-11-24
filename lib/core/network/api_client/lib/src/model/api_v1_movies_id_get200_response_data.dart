//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/api_v1_movies_id_get200_response_data_media.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_movies_id_get200_response_data.g.dart';

/// ApiV1MoviesIdGet200ResponseData
///
/// Properties:
/// * [id] 
/// * [duration] - Movie duration in minutes
/// * [trailerUrl] 
/// * [filePath] 
/// * [fileSize] - File size in bytes
/// * [fileModifiedAt] 
/// * [streamUrl] - URL to stream the movie
/// * [mediaId] 
/// * [media] 
@BuiltValue()
abstract class ApiV1MoviesIdGet200ResponseData implements Built<ApiV1MoviesIdGet200ResponseData, ApiV1MoviesIdGet200ResponseDataBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  /// Movie duration in minutes
  @BuiltValueField(wireName: r'duration')
  num? get duration;

  @BuiltValueField(wireName: r'trailerUrl')
  String? get trailerUrl;

  @BuiltValueField(wireName: r'filePath')
  String? get filePath;

  /// File size in bytes
  @BuiltValueField(wireName: r'fileSize')
  String? get fileSize;

  @BuiltValueField(wireName: r'fileModifiedAt')
  DateTime? get fileModifiedAt;

  /// URL to stream the movie
  @BuiltValueField(wireName: r'streamUrl')
  String? get streamUrl;

  @BuiltValueField(wireName: r'mediaId')
  String? get mediaId;

  @BuiltValueField(wireName: r'media')
  ApiV1MoviesIdGet200ResponseDataMedia? get media;

  ApiV1MoviesIdGet200ResponseData._();

  factory ApiV1MoviesIdGet200ResponseData([void updates(ApiV1MoviesIdGet200ResponseDataBuilder b)]) = _$ApiV1MoviesIdGet200ResponseData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1MoviesIdGet200ResponseDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1MoviesIdGet200ResponseData> get serializer => _$ApiV1MoviesIdGet200ResponseDataSerializer();
}

class _$ApiV1MoviesIdGet200ResponseDataSerializer implements PrimitiveSerializer<ApiV1MoviesIdGet200ResponseData> {
  @override
  final Iterable<Type> types = const [ApiV1MoviesIdGet200ResponseData, _$ApiV1MoviesIdGet200ResponseData];

  @override
  final String wireName = r'ApiV1MoviesIdGet200ResponseData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1MoviesIdGet200ResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.duration != null) {
      yield r'duration';
      yield serializers.serialize(
        object.duration,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.trailerUrl != null) {
      yield r'trailerUrl';
      yield serializers.serialize(
        object.trailerUrl,
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
    if (object.fileModifiedAt != null) {
      yield r'fileModifiedAt';
      yield serializers.serialize(
        object.fileModifiedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.streamUrl != null) {
      yield r'streamUrl';
      yield serializers.serialize(
        object.streamUrl,
        specifiedType: const FullType(String),
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
        specifiedType: const FullType(ApiV1MoviesIdGet200ResponseDataMedia),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1MoviesIdGet200ResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1MoviesIdGet200ResponseDataBuilder result,
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
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.duration = valueDes;
          break;
        case r'trailerUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.trailerUrl = valueDes;
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
        case r'fileModifiedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.fileModifiedAt = valueDes;
          break;
        case r'streamUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.streamUrl = valueDes;
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
            specifiedType: const FullType(ApiV1MoviesIdGet200ResponseDataMedia),
          ) as ApiV1MoviesIdGet200ResponseDataMedia;
          result.media.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1MoviesIdGet200ResponseData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1MoviesIdGet200ResponseDataBuilder();
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

