//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/public_settings_scan_settings_media_type_depth.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_settings_request_scan_settings.g.dart';

/// Default scan configuration options
///
/// Properties:
/// * [mediaType] 
/// * [maxDepth] 
/// * [mediaTypeDepth] 
/// * [fileExtensions] 
/// * [filenamePattern] 
/// * [excludePattern] 
/// * [includePattern] 
/// * [directoryPattern] 
/// * [excludeDirectories] 
/// * [includeDirectories] 
/// * [rescan] 
/// * [batchScan] 
/// * [minFileSize] 
/// * [maxFileSize] 
/// * [followSymlinks] 
@BuiltValue()
abstract class UpdateSettingsRequestScanSettings implements Built<UpdateSettingsRequestScanSettings, UpdateSettingsRequestScanSettingsBuilder> {
  @BuiltValueField(wireName: r'mediaType')
  UpdateSettingsRequestScanSettingsMediaTypeEnum? get mediaType;
  // enum mediaTypeEnum {  movie,  tv,  };

  @BuiltValueField(wireName: r'maxDepth')
  num? get maxDepth;

  @BuiltValueField(wireName: r'mediaTypeDepth')
  PublicSettingsScanSettingsMediaTypeDepth? get mediaTypeDepth;

  @BuiltValueField(wireName: r'fileExtensions')
  BuiltList<String>? get fileExtensions;

  @BuiltValueField(wireName: r'filenamePattern')
  String? get filenamePattern;

  @BuiltValueField(wireName: r'excludePattern')
  String? get excludePattern;

  @BuiltValueField(wireName: r'includePattern')
  String? get includePattern;

  @BuiltValueField(wireName: r'directoryPattern')
  String? get directoryPattern;

  @BuiltValueField(wireName: r'excludeDirectories')
  BuiltList<String>? get excludeDirectories;

  @BuiltValueField(wireName: r'includeDirectories')
  BuiltList<String>? get includeDirectories;

  @BuiltValueField(wireName: r'rescan')
  bool? get rescan;

  @BuiltValueField(wireName: r'batchScan')
  bool? get batchScan;

  @BuiltValueField(wireName: r'minFileSize')
  num? get minFileSize;

  @BuiltValueField(wireName: r'maxFileSize')
  num? get maxFileSize;

  @BuiltValueField(wireName: r'followSymlinks')
  bool? get followSymlinks;

  UpdateSettingsRequestScanSettings._();

  factory UpdateSettingsRequestScanSettings([void updates(UpdateSettingsRequestScanSettingsBuilder b)]) = _$UpdateSettingsRequestScanSettings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateSettingsRequestScanSettingsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateSettingsRequestScanSettings> get serializer => _$UpdateSettingsRequestScanSettingsSerializer();
}

class _$UpdateSettingsRequestScanSettingsSerializer implements PrimitiveSerializer<UpdateSettingsRequestScanSettings> {
  @override
  final Iterable<Type> types = const [UpdateSettingsRequestScanSettings, _$UpdateSettingsRequestScanSettings];

  @override
  final String wireName = r'UpdateSettingsRequestScanSettings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateSettingsRequestScanSettings object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.mediaType != null) {
      yield r'mediaType';
      yield serializers.serialize(
        object.mediaType,
        specifiedType: const FullType(UpdateSettingsRequestScanSettingsMediaTypeEnum),
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
    UpdateSettingsRequestScanSettings object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateSettingsRequestScanSettingsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'mediaType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UpdateSettingsRequestScanSettingsMediaTypeEnum),
          ) as UpdateSettingsRequestScanSettingsMediaTypeEnum;
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
  UpdateSettingsRequestScanSettings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateSettingsRequestScanSettingsBuilder();
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

class UpdateSettingsRequestScanSettingsMediaTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'movie')
  static const UpdateSettingsRequestScanSettingsMediaTypeEnum movie = _$updateSettingsRequestScanSettingsMediaTypeEnum_movie;
  @BuiltValueEnumConst(wireName: r'tv')
  static const UpdateSettingsRequestScanSettingsMediaTypeEnum tv = _$updateSettingsRequestScanSettingsMediaTypeEnum_tv;

  static Serializer<UpdateSettingsRequestScanSettingsMediaTypeEnum> get serializer => _$updateSettingsRequestScanSettingsMediaTypeEnumSerializer;

  const UpdateSettingsRequestScanSettingsMediaTypeEnum._(String name): super(name);

  static BuiltSet<UpdateSettingsRequestScanSettingsMediaTypeEnum> get values => _$updateSettingsRequestScanSettingsMediaTypeEnumValues;
  static UpdateSettingsRequestScanSettingsMediaTypeEnum valueOf(String name) => _$updateSettingsRequestScanSettingsMediaTypeEnumValueOf(name);
}

