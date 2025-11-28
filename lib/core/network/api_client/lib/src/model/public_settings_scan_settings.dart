//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/public_settings_scan_settings_media_type_depth.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_settings_scan_settings.g.dart';

/// Default scan configuration options
///
/// Properties:
/// * [mediaType] - Type of media to scan (movie or tv)
/// * [maxDepth] - Maximum directory depth to scan
/// * [mediaTypeDepth] 
/// * [fileExtensions] - File extensions to include in the scan
/// * [filenamePattern] - Regex pattern to match filenames
/// * [excludePattern] - Regex pattern to exclude files/directories
/// * [includePattern] - Regex pattern to include files/directories
/// * [directoryPattern] - Regex pattern to match directory names
/// * [excludeDirectories] - List of directory names to exclude
/// * [includeDirectories] - List of directory names to include
/// * [rescan] - Re-fetch metadata even if it already exists
/// * [batchScan] - Enable batch scanning mode for large libraries
/// * [minFileSize] - Minimum file size in bytes
/// * [maxFileSize] - Maximum file size in bytes
/// * [followSymlinks] - Whether to follow symbolic links during scanning
@BuiltValue()
abstract class PublicSettingsScanSettings implements Built<PublicSettingsScanSettings, PublicSettingsScanSettingsBuilder> {
  /// Type of media to scan (movie or tv)
  @BuiltValueField(wireName: r'mediaType')
  PublicSettingsScanSettingsMediaTypeEnum? get mediaType;
  // enum mediaTypeEnum {  movie,  tv,  };

  /// Maximum directory depth to scan
  @BuiltValueField(wireName: r'maxDepth')
  num? get maxDepth;

  @BuiltValueField(wireName: r'mediaTypeDepth')
  PublicSettingsScanSettingsMediaTypeDepth? get mediaTypeDepth;

  /// File extensions to include in the scan
  @BuiltValueField(wireName: r'fileExtensions')
  BuiltList<String>? get fileExtensions;

  /// Regex pattern to match filenames
  @BuiltValueField(wireName: r'filenamePattern')
  String? get filenamePattern;

  /// Regex pattern to exclude files/directories
  @BuiltValueField(wireName: r'excludePattern')
  String? get excludePattern;

  /// Regex pattern to include files/directories
  @BuiltValueField(wireName: r'includePattern')
  String? get includePattern;

  /// Regex pattern to match directory names
  @BuiltValueField(wireName: r'directoryPattern')
  String? get directoryPattern;

  /// List of directory names to exclude
  @BuiltValueField(wireName: r'excludeDirectories')
  BuiltList<String>? get excludeDirectories;

  /// List of directory names to include
  @BuiltValueField(wireName: r'includeDirectories')
  BuiltList<String>? get includeDirectories;

  /// Re-fetch metadata even if it already exists
  @BuiltValueField(wireName: r'rescan')
  bool? get rescan;

  /// Enable batch scanning mode for large libraries
  @BuiltValueField(wireName: r'batchScan')
  bool? get batchScan;

  /// Minimum file size in bytes
  @BuiltValueField(wireName: r'minFileSize')
  num? get minFileSize;

  /// Maximum file size in bytes
  @BuiltValueField(wireName: r'maxFileSize')
  num? get maxFileSize;

  /// Whether to follow symbolic links during scanning
  @BuiltValueField(wireName: r'followSymlinks')
  bool? get followSymlinks;

  PublicSettingsScanSettings._();

  factory PublicSettingsScanSettings([void updates(PublicSettingsScanSettingsBuilder b)]) = _$PublicSettingsScanSettings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicSettingsScanSettingsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicSettingsScanSettings> get serializer => _$PublicSettingsScanSettingsSerializer();
}

class _$PublicSettingsScanSettingsSerializer implements PrimitiveSerializer<PublicSettingsScanSettings> {
  @override
  final Iterable<Type> types = const [PublicSettingsScanSettings, _$PublicSettingsScanSettings];

  @override
  final String wireName = r'PublicSettingsScanSettings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicSettingsScanSettings object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.mediaType != null) {
      yield r'mediaType';
      yield serializers.serialize(
        object.mediaType,
        specifiedType: const FullType(PublicSettingsScanSettingsMediaTypeEnum),
      );
    }
    if (object.maxDepth != null) {
      yield r'maxDepth';
      yield serializers.serialize(
        object.maxDepth,
        specifiedType: const FullType(num),
      );
    }
    if (object.mediaTypeDepth != null) {
      yield r'mediaTypeDepth';
      yield serializers.serialize(
        object.mediaTypeDepth,
        specifiedType: const FullType(PublicSettingsScanSettingsMediaTypeDepth),
      );
    }
    if (object.fileExtensions != null) {
      yield r'fileExtensions';
      yield serializers.serialize(
        object.fileExtensions,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.filenamePattern != null) {
      yield r'filenamePattern';
      yield serializers.serialize(
        object.filenamePattern,
        specifiedType: const FullType(String),
      );
    }
    if (object.excludePattern != null) {
      yield r'excludePattern';
      yield serializers.serialize(
        object.excludePattern,
        specifiedType: const FullType(String),
      );
    }
    if (object.includePattern != null) {
      yield r'includePattern';
      yield serializers.serialize(
        object.includePattern,
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
    if (object.excludeDirectories != null) {
      yield r'excludeDirectories';
      yield serializers.serialize(
        object.excludeDirectories,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.includeDirectories != null) {
      yield r'includeDirectories';
      yield serializers.serialize(
        object.includeDirectories,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
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
    if (object.minFileSize != null) {
      yield r'minFileSize';
      yield serializers.serialize(
        object.minFileSize,
        specifiedType: const FullType(num),
      );
    }
    if (object.maxFileSize != null) {
      yield r'maxFileSize';
      yield serializers.serialize(
        object.maxFileSize,
        specifiedType: const FullType(num),
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
    PublicSettingsScanSettings object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicSettingsScanSettingsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'mediaType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicSettingsScanSettingsMediaTypeEnum),
          ) as PublicSettingsScanSettingsMediaTypeEnum;
          result.mediaType = valueDes;
          break;
        case r'maxDepth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.maxDepth = valueDes;
          break;
        case r'mediaTypeDepth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicSettingsScanSettingsMediaTypeDepth),
          ) as PublicSettingsScanSettingsMediaTypeDepth;
          result.mediaTypeDepth.replace(valueDes);
          break;
        case r'fileExtensions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.fileExtensions.replace(valueDes);
          break;
        case r'filenamePattern':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.filenamePattern = valueDes;
          break;
        case r'excludePattern':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.excludePattern = valueDes;
          break;
        case r'includePattern':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.includePattern = valueDes;
          break;
        case r'directoryPattern':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.directoryPattern = valueDes;
          break;
        case r'excludeDirectories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.excludeDirectories.replace(valueDes);
          break;
        case r'includeDirectories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.includeDirectories.replace(valueDes);
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
        case r'minFileSize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.minFileSize = valueDes;
          break;
        case r'maxFileSize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.maxFileSize = valueDes;
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
  PublicSettingsScanSettings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicSettingsScanSettingsBuilder();
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

class PublicSettingsScanSettingsMediaTypeEnum extends EnumClass {

  /// Type of media to scan (movie or tv)
  @BuiltValueEnumConst(wireName: r'movie')
  static const PublicSettingsScanSettingsMediaTypeEnum movie = _$publicSettingsScanSettingsMediaTypeEnum_movie;
  /// Type of media to scan (movie or tv)
  @BuiltValueEnumConst(wireName: r'tv')
  static const PublicSettingsScanSettingsMediaTypeEnum tv = _$publicSettingsScanSettingsMediaTypeEnum_tv;

  static Serializer<PublicSettingsScanSettingsMediaTypeEnum> get serializer => _$publicSettingsScanSettingsMediaTypeEnumSerializer;

  const PublicSettingsScanSettingsMediaTypeEnum._(String name): super(name);

  static BuiltSet<PublicSettingsScanSettingsMediaTypeEnum> get values => _$publicSettingsScanSettingsMediaTypeEnumValues;
  static PublicSettingsScanSettingsMediaTypeEnum valueOf(String name) => _$publicSettingsScanSettingsMediaTypeEnumValueOf(name);
}

