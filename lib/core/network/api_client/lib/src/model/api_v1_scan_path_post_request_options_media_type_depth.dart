//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_scan_path_post_request_options_media_type_depth.g.dart';

/// Per-media-type depth configuration. Allows different depths for movies vs TV shows. Defaults to database settings if not provided, or {movie: 2, tv: 4} if no database setting exists. You can provide only movie or only tv to override just one type. 
///
/// Properties:
/// * [movie] - Maximum directory depth for movie scans (0-10)
/// * [tv] - Maximum directory depth for TV show scans (0-10)
@BuiltValue()
abstract class ApiV1ScanPathPostRequestOptionsMediaTypeDepth implements Built<ApiV1ScanPathPostRequestOptionsMediaTypeDepth, ApiV1ScanPathPostRequestOptionsMediaTypeDepthBuilder> {
  /// Maximum directory depth for movie scans (0-10)
  @BuiltValueField(wireName: r'movie')
  num? get movie;

  /// Maximum directory depth for TV show scans (0-10)
  @BuiltValueField(wireName: r'tv')
  num? get tv;

  ApiV1ScanPathPostRequestOptionsMediaTypeDepth._();

  factory ApiV1ScanPathPostRequestOptionsMediaTypeDepth([void updates(ApiV1ScanPathPostRequestOptionsMediaTypeDepthBuilder b)]) = _$ApiV1ScanPathPostRequestOptionsMediaTypeDepth;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1ScanPathPostRequestOptionsMediaTypeDepthBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1ScanPathPostRequestOptionsMediaTypeDepth> get serializer => _$ApiV1ScanPathPostRequestOptionsMediaTypeDepthSerializer();
}

class _$ApiV1ScanPathPostRequestOptionsMediaTypeDepthSerializer implements PrimitiveSerializer<ApiV1ScanPathPostRequestOptionsMediaTypeDepth> {
  @override
  final Iterable<Type> types = const [ApiV1ScanPathPostRequestOptionsMediaTypeDepth, _$ApiV1ScanPathPostRequestOptionsMediaTypeDepth];

  @override
  final String wireName = r'ApiV1ScanPathPostRequestOptionsMediaTypeDepth';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1ScanPathPostRequestOptionsMediaTypeDepth object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.movie != null) {
      yield r'movie';
      yield serializers.serialize(
        object.movie,
        specifiedType: const FullType(num),
      );
    }
    if (object.tv != null) {
      yield r'tv';
      yield serializers.serialize(
        object.tv,
        specifiedType: const FullType(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1ScanPathPostRequestOptionsMediaTypeDepth object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1ScanPathPostRequestOptionsMediaTypeDepthBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'movie':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.movie = valueDes;
          break;
        case r'tv':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.tv = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1ScanPathPostRequestOptionsMediaTypeDepth deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1ScanPathPostRequestOptionsMediaTypeDepthBuilder();
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

