//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/api_v1_movies_get200_response_inner_media.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_movies_get200_response_inner.g.dart';

/// ApiV1MoviesGet200ResponseInner
///
/// Properties:
/// * [id] 
/// * [duration] - Movie duration in minutes
/// * [trailerUrl] 
/// * [filePath] 
/// * [fileSize] - File size in bytes
/// * [fileModifiedAt] 
/// * [mediaId] 
/// * [media] 
@BuiltValue()
abstract class ApiV1MoviesGet200ResponseInner implements Built<ApiV1MoviesGet200ResponseInner, ApiV1MoviesGet200ResponseInnerBuilder> {
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

  @BuiltValueField(wireName: r'mediaId')
  String? get mediaId;

  @BuiltValueField(wireName: r'media')
  ApiV1MoviesGet200ResponseInnerMedia? get media;

  ApiV1MoviesGet200ResponseInner._();

  factory ApiV1MoviesGet200ResponseInner([void updates(ApiV1MoviesGet200ResponseInnerBuilder b)]) = _$ApiV1MoviesGet200ResponseInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1MoviesGet200ResponseInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1MoviesGet200ResponseInner> get serializer => _$ApiV1MoviesGet200ResponseInnerSerializer();
}

class _$ApiV1MoviesGet200ResponseInnerSerializer implements PrimitiveSerializer<ApiV1MoviesGet200ResponseInner> {
  @override
  final Iterable<Type> types = const [ApiV1MoviesGet200ResponseInner, _$ApiV1MoviesGet200ResponseInner];

  @override
  final String wireName = r'ApiV1MoviesGet200ResponseInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1MoviesGet200ResponseInner object, {
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
        specifiedType: const FullType(ApiV1MoviesGet200ResponseInnerMedia),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1MoviesGet200ResponseInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1MoviesGet200ResponseInnerBuilder result,
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
            specifiedType: const FullType(ApiV1MoviesGet200ResponseInnerMedia),
          ) as ApiV1MoviesGet200ResponseInnerMedia;
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
  ApiV1MoviesGet200ResponseInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1MoviesGet200ResponseInnerBuilder();
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

