//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
// External packages
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:openapi/src/model/api_v1_movies_get200_response_data_inner_media.dart';


part 'api_v1_search_get200_response_data_movies_inner.g.dart';

/// ApiV1SearchGet200ResponseDataMoviesInner
///
/// Properties:
/// * [id] 
/// * [duration] 
/// * [trailerUrl] 
/// * [filePath] 
/// * [fileSize] 
/// * [fileModifiedAt] 
/// * [mediaId] 
/// * [media] 
@BuiltValue()
abstract class ApiV1SearchGet200ResponseDataMoviesInner implements Built<ApiV1SearchGet200ResponseDataMoviesInner, ApiV1SearchGet200ResponseDataMoviesInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'duration')
  num? get duration;

  @BuiltValueField(wireName: r'trailerUrl')
  String? get trailerUrl;

  @BuiltValueField(wireName: r'filePath')
  String? get filePath;

  @BuiltValueField(wireName: r'fileSize')
  String? get fileSize;

  @BuiltValueField(wireName: r'fileModifiedAt')
  DateTime? get fileModifiedAt;

  @BuiltValueField(wireName: r'mediaId')
  String? get mediaId;

  @BuiltValueField(wireName: r'media')
  ApiV1MoviesGet200ResponseDataInnerMedia? get media;

  ApiV1SearchGet200ResponseDataMoviesInner._();

  factory ApiV1SearchGet200ResponseDataMoviesInner([void updates(ApiV1SearchGet200ResponseDataMoviesInnerBuilder b)]) = _$ApiV1SearchGet200ResponseDataMoviesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1SearchGet200ResponseDataMoviesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1SearchGet200ResponseDataMoviesInner> get serializer => _$ApiV1SearchGet200ResponseDataMoviesInnerSerializer();
}

class _$ApiV1SearchGet200ResponseDataMoviesInnerSerializer implements PrimitiveSerializer<ApiV1SearchGet200ResponseDataMoviesInner> {
  @override
  final Iterable<Type> types = const [ApiV1SearchGet200ResponseDataMoviesInner, _$ApiV1SearchGet200ResponseDataMoviesInner];

  @override
  final String wireName = r'ApiV1SearchGet200ResponseDataMoviesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1SearchGet200ResponseDataMoviesInner object, {
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
        specifiedType: const FullType(ApiV1MoviesGet200ResponseDataInnerMedia),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1SearchGet200ResponseDataMoviesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1SearchGet200ResponseDataMoviesInnerBuilder result,
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
            specifiedType: const FullType(ApiV1MoviesGet200ResponseDataInnerMedia),
          ) as ApiV1MoviesGet200ResponseDataInnerMedia;
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
  ApiV1SearchGet200ResponseDataMoviesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1SearchGet200ResponseDataMoviesInnerBuilder();
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

