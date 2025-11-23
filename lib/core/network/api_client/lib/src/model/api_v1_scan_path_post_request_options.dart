//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
// External packages
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';


part 'api_v1_scan_path_post_request_options.g.dart';

/// ApiV1ScanPathPostRequestOptions
///
/// Properties:
/// * [maxDepth] - Maximum directory depth to scan (0-10)
/// * [mediaType] - Media type for TMDB API calls (movie or tv). Required for proper metadata fetching.
/// * [fileExtensions] - File extensions to include in the scan
/// * [libraryName] - Name for the library. If not provided, uses \"Library - {path}\"
/// * [rescan] - If true, re-fetches metadata from TMDB even if it already exists in the database. If false or omitted, skips items that already have metadata.
@BuiltValue()
abstract class ApiV1ScanPathPostRequestOptions implements Built<ApiV1ScanPathPostRequestOptions, ApiV1ScanPathPostRequestOptionsBuilder> {
  /// Maximum directory depth to scan (0-10)
  @BuiltValueField(wireName: r'maxDepth')
  num? get maxDepth;

  /// Media type for TMDB API calls (movie or tv). Required for proper metadata fetching.
  @BuiltValueField(wireName: r'mediaType')
  ApiV1ScanPathPostRequestOptionsMediaTypeEnum? get mediaType;
  // enum mediaTypeEnum {  movie,  tv,  };

  /// File extensions to include in the scan
  @BuiltValueField(wireName: r'fileExtensions')
  BuiltList<String>? get fileExtensions;

  /// Name for the library. If not provided, uses \"Library - {path}\"
  @BuiltValueField(wireName: r'libraryName')
  String? get libraryName;

  /// If true, re-fetches metadata from TMDB even if it already exists in the database. If false or omitted, skips items that already have metadata.
  @BuiltValueField(wireName: r'rescan')
  bool? get rescan;

  ApiV1ScanPathPostRequestOptions._();

  factory ApiV1ScanPathPostRequestOptions([void updates(ApiV1ScanPathPostRequestOptionsBuilder b)]) = _$ApiV1ScanPathPostRequestOptions;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1ScanPathPostRequestOptionsBuilder b) => b
      ..fileExtensions = ListBuilder()
      ..rescan = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1ScanPathPostRequestOptions> get serializer => _$ApiV1ScanPathPostRequestOptionsSerializer();
}

class _$ApiV1ScanPathPostRequestOptionsSerializer implements PrimitiveSerializer<ApiV1ScanPathPostRequestOptions> {
  @override
  final Iterable<Type> types = const [ApiV1ScanPathPostRequestOptions, _$ApiV1ScanPathPostRequestOptions];

  @override
  final String wireName = r'ApiV1ScanPathPostRequestOptions';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1ScanPathPostRequestOptions object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.maxDepth != null) {
      yield r'maxDepth';
      yield serializers.serialize(
        object.maxDepth,
        specifiedType: const FullType(num),
      );
    }
    if (object.mediaType != null) {
      yield r'mediaType';
      yield serializers.serialize(
        object.mediaType,
        specifiedType: const FullType(ApiV1ScanPathPostRequestOptionsMediaTypeEnum),
      );
    }
    if (object.fileExtensions != null) {
      yield r'fileExtensions';
      yield serializers.serialize(
        object.fileExtensions,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.libraryName != null) {
      yield r'libraryName';
      yield serializers.serialize(
        object.libraryName,
        specifiedType: const FullType(String),
      );
    }
    if (object.rescan != null) {
      yield r'rescan';
      yield serializers.serialize(
        object.rescan,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1ScanPathPostRequestOptions object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1ScanPathPostRequestOptionsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'maxDepth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.maxDepth = valueDes;
          break;
        case r'mediaType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1ScanPathPostRequestOptionsMediaTypeEnum),
          ) as ApiV1ScanPathPostRequestOptionsMediaTypeEnum;
          result.mediaType = valueDes;
          break;
        case r'fileExtensions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.fileExtensions.replace(valueDes);
          break;
        case r'libraryName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.libraryName = valueDes;
          break;
        case r'rescan':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.rescan = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1ScanPathPostRequestOptions deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1ScanPathPostRequestOptionsBuilder();
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

class ApiV1ScanPathPostRequestOptionsMediaTypeEnum extends EnumClass {

  /// Media type for TMDB API calls (movie or tv). Required for proper metadata fetching.
  @BuiltValueEnumConst(wireName: r'movie')
  static const ApiV1ScanPathPostRequestOptionsMediaTypeEnum movie = _$apiV1ScanPathPostRequestOptionsMediaTypeEnum_movie;
  /// Media type for TMDB API calls (movie or tv). Required for proper metadata fetching.
  @BuiltValueEnumConst(wireName: r'tv')
  static const ApiV1ScanPathPostRequestOptionsMediaTypeEnum tv = _$apiV1ScanPathPostRequestOptionsMediaTypeEnum_tv;

  static Serializer<ApiV1ScanPathPostRequestOptionsMediaTypeEnum> get serializer => _$apiV1ScanPathPostRequestOptionsMediaTypeEnumSerializer;

  const ApiV1ScanPathPostRequestOptionsMediaTypeEnum._(String name): super(name);

  static BuiltSet<ApiV1ScanPathPostRequestOptionsMediaTypeEnum> get values => _$apiV1ScanPathPostRequestOptionsMediaTypeEnumValues;
  static ApiV1ScanPathPostRequestOptionsMediaTypeEnum valueOf(String name) => _$apiV1ScanPathPostRequestOptionsMediaTypeEnumValueOf(name);
}

