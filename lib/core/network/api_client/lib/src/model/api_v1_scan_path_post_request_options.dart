//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/api_v1_scan_path_post_request_options_media_type_depth.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_scan_path_post_request_options.g.dart';

/// Scan configuration options. All options are optional and will default to values stored in database settings. Any options provided here will override the corresponding database settings for this scan only. 
///
/// Properties:
/// * [mediaType] - Type of media to scan (movie or tv). Required for proper metadata fetching. Defaults to database settings if not provided, or \"movie\" if no database setting exists. 
/// * [mediaTypeDepth] 
/// * [filenamePattern] - Regex pattern to match filenames. Only files matching this pattern will be scanned. Example: '^.*S\\\\d{2}E\\\\d{2}.*$' for episode files (S01E01, S02E05, etc.) Defaults to database settings if not provided. If not set in database, all files matching video extensions are scanned. 
/// * [directoryPattern] - Regex pattern to match directory names. Only directories matching this pattern will be scanned. Useful for specific folder structures (e.g., \"^Season \\\\d+$\" to only scan Season folders). Defaults to database settings if not provided. If not set in database, all directories are scanned. 
/// * [rescan] - If true, re-fetches metadata even if it already exists in the database. If false, skips items that already have metadata. Defaults to database settings if not provided, or false if no database setting exists. 
/// * [batchScan] - Enable batch scanning mode for large libraries. Automatically enabled for TV shows. Batches: 5 shows or 25 movies per batch. Useful for slow storage (FTP, SMB, etc.) Defaults to database settings if not provided, or false if no database setting exists. 
/// * [followSymlinks] - Whether to follow symbolic links during scanning. Defaults to database settings if not provided, or true if no database setting exists. 
@BuiltValue()
abstract class ApiV1ScanPathPostRequestOptions implements Built<ApiV1ScanPathPostRequestOptions, ApiV1ScanPathPostRequestOptionsBuilder> {
  /// Type of media to scan (movie or tv). Required for proper metadata fetching. Defaults to database settings if not provided, or \"movie\" if no database setting exists. 
  @BuiltValueField(wireName: r'mediaType')
  ApiV1ScanPathPostRequestOptionsMediaTypeEnum? get mediaType;
  // enum mediaTypeEnum {  movie,  tv,  };

  @BuiltValueField(wireName: r'mediaTypeDepth')
  ApiV1ScanPathPostRequestOptionsMediaTypeDepth? get mediaTypeDepth;

  /// Regex pattern to match filenames. Only files matching this pattern will be scanned. Example: '^.*S\\\\d{2}E\\\\d{2}.*$' for episode files (S01E01, S02E05, etc.) Defaults to database settings if not provided. If not set in database, all files matching video extensions are scanned. 
  @BuiltValueField(wireName: r'filenamePattern')
  String? get filenamePattern;

  /// Regex pattern to match directory names. Only directories matching this pattern will be scanned. Useful for specific folder structures (e.g., \"^Season \\\\d+$\" to only scan Season folders). Defaults to database settings if not provided. If not set in database, all directories are scanned. 
  @BuiltValueField(wireName: r'directoryPattern')
  String? get directoryPattern;

  /// If true, re-fetches metadata even if it already exists in the database. If false, skips items that already have metadata. Defaults to database settings if not provided, or false if no database setting exists. 
  @BuiltValueField(wireName: r'rescan')
  bool? get rescan;

  /// Enable batch scanning mode for large libraries. Automatically enabled for TV shows. Batches: 5 shows or 25 movies per batch. Useful for slow storage (FTP, SMB, etc.) Defaults to database settings if not provided, or false if no database setting exists. 
  @BuiltValueField(wireName: r'batchScan')
  bool? get batchScan;

  /// Whether to follow symbolic links during scanning. Defaults to database settings if not provided, or true if no database setting exists. 
  @BuiltValueField(wireName: r'followSymlinks')
  bool? get followSymlinks;

  ApiV1ScanPathPostRequestOptions._();

  factory ApiV1ScanPathPostRequestOptions([void updates(ApiV1ScanPathPostRequestOptionsBuilder b)]) = _$ApiV1ScanPathPostRequestOptions;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1ScanPathPostRequestOptionsBuilder b) => b
      ..mediaType = ApiV1ScanPathPostRequestOptionsMediaTypeEnum.valueOf('movie');

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
    if (object.mediaType != null) {
      yield r'mediaType';
      yield serializers.serialize(
        object.mediaType,
        specifiedType: const FullType(ApiV1ScanPathPostRequestOptionsMediaTypeEnum),
      );
    }
    if (object.mediaTypeDepth != null) {
      yield r'mediaTypeDepth';
      yield serializers.serialize(
        object.mediaTypeDepth,
        specifiedType: const FullType(ApiV1ScanPathPostRequestOptionsMediaTypeDepth),
      );
    }
    if (object.filenamePattern != null) {
      yield r'filenamePattern';
      yield serializers.serialize(
        object.filenamePattern,
        specifiedType: const FullType(String),
      );
    }
    if (object.directoryPattern != null) {
      yield r'directoryPattern';
      yield serializers.serialize(
        object.directoryPattern,
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
    if (object.batchScan != null) {
      yield r'batchScan';
      yield serializers.serialize(
        object.batchScan,
        specifiedType: const FullType(bool),
      );
    }
    if (object.followSymlinks != null) {
      yield r'followSymlinks';
      yield serializers.serialize(
        object.followSymlinks,
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
        case r'mediaType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1ScanPathPostRequestOptionsMediaTypeEnum),
          ) as ApiV1ScanPathPostRequestOptionsMediaTypeEnum;
          result.mediaType = valueDes;
          break;
        case r'mediaTypeDepth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1ScanPathPostRequestOptionsMediaTypeDepth),
          ) as ApiV1ScanPathPostRequestOptionsMediaTypeDepth;
          result.mediaTypeDepth.replace(valueDes);
          break;
        case r'filenamePattern':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.filenamePattern = valueDes;
          break;
        case r'directoryPattern':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.directoryPattern = valueDes;
          break;
        case r'rescan':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.rescan = valueDes;
          break;
        case r'batchScan':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.batchScan = valueDes;
          break;
        case r'followSymlinks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.followSymlinks = valueDes;
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

  /// Type of media to scan (movie or tv). Required for proper metadata fetching. Defaults to database settings if not provided, or \"movie\" if no database setting exists. 
  @BuiltValueEnumConst(wireName: r'movie')
  static const ApiV1ScanPathPostRequestOptionsMediaTypeEnum movie = _$apiV1ScanPathPostRequestOptionsMediaTypeEnum_movie;
  /// Type of media to scan (movie or tv). Required for proper metadata fetching. Defaults to database settings if not provided, or \"movie\" if no database setting exists. 
  @BuiltValueEnumConst(wireName: r'tv')
  static const ApiV1ScanPathPostRequestOptionsMediaTypeEnum tv = _$apiV1ScanPathPostRequestOptionsMediaTypeEnum_tv;

  static Serializer<ApiV1ScanPathPostRequestOptionsMediaTypeEnum> get serializer => _$apiV1ScanPathPostRequestOptionsMediaTypeEnumSerializer;

  const ApiV1ScanPathPostRequestOptionsMediaTypeEnum._(String name): super(name);

  static BuiltSet<ApiV1ScanPathPostRequestOptionsMediaTypeEnum> get values => _$apiV1ScanPathPostRequestOptionsMediaTypeEnumValues;
  static ApiV1ScanPathPostRequestOptionsMediaTypeEnum valueOf(String name) => _$apiV1ScanPathPostRequestOptionsMediaTypeEnumValueOf(name);
}

