//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
// External packages
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:openapi/src/model/api_v1_scan_path_post200_response_data_cache_stats.dart';


part 'api_v1_scan_path_post200_response_data.g.dart';

/// ApiV1ScanPathPost200ResponseData
///
/// Properties:
/// * [libraryId] - The ID of the library that was scanned
/// * [libraryName] - The name of the library
/// * [totalFiles] - Total number of media files discovered
/// * [totalSaved] - Total number saved to database
/// * [cacheStats] 
@BuiltValue()
abstract class ApiV1ScanPathPost200ResponseData implements Built<ApiV1ScanPathPost200ResponseData, ApiV1ScanPathPost200ResponseDataBuilder> {
  /// The ID of the library that was scanned
  @BuiltValueField(wireName: r'libraryId')
  String? get libraryId;

  /// The name of the library
  @BuiltValueField(wireName: r'libraryName')
  String? get libraryName;

  /// Total number of media files discovered
  @BuiltValueField(wireName: r'totalFiles')
  num? get totalFiles;

  /// Total number saved to database
  @BuiltValueField(wireName: r'totalSaved')
  num? get totalSaved;

  @BuiltValueField(wireName: r'cacheStats')
  ApiV1ScanPathPost200ResponseDataCacheStats? get cacheStats;

  ApiV1ScanPathPost200ResponseData._();

  factory ApiV1ScanPathPost200ResponseData([void updates(ApiV1ScanPathPost200ResponseDataBuilder b)]) = _$ApiV1ScanPathPost200ResponseData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1ScanPathPost200ResponseDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1ScanPathPost200ResponseData> get serializer => _$ApiV1ScanPathPost200ResponseDataSerializer();
}

class _$ApiV1ScanPathPost200ResponseDataSerializer implements PrimitiveSerializer<ApiV1ScanPathPost200ResponseData> {
  @override
  final Iterable<Type> types = const [ApiV1ScanPathPost200ResponseData, _$ApiV1ScanPathPost200ResponseData];

  @override
  final String wireName = r'ApiV1ScanPathPost200ResponseData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1ScanPathPost200ResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.libraryId != null) {
      yield r'libraryId';
      yield serializers.serialize(
        object.libraryId,
        specifiedType: const FullType(String),
      );
    }
    if (object.libraryName != null) {
      yield r'libraryName';
      yield serializers.serialize(
        object.libraryName,
        specifiedType: const FullType(String),
      );
    }
    if (object.totalFiles != null) {
      yield r'totalFiles';
      yield serializers.serialize(
        object.totalFiles,
        specifiedType: const FullType(num),
      );
    }
    if (object.totalSaved != null) {
      yield r'totalSaved';
      yield serializers.serialize(
        object.totalSaved,
        specifiedType: const FullType(num),
      );
    }
    if (object.cacheStats != null) {
      yield r'cacheStats';
      yield serializers.serialize(
        object.cacheStats,
        specifiedType: const FullType(ApiV1ScanPathPost200ResponseDataCacheStats),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1ScanPathPost200ResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1ScanPathPost200ResponseDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'libraryId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.libraryId = valueDes;
          break;
        case r'libraryName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.libraryName = valueDes;
          break;
        case r'totalFiles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.totalFiles = valueDes;
          break;
        case r'totalSaved':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.totalSaved = valueDes;
          break;
        case r'cacheStats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1ScanPathPost200ResponseDataCacheStats),
          ) as ApiV1ScanPathPost200ResponseDataCacheStats;
          result.cacheStats.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1ScanPathPost200ResponseData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1ScanPathPost200ResponseDataBuilder();
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

