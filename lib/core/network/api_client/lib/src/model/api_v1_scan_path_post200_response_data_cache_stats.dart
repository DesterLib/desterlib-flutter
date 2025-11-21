//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_scan_path_post200_response_data_cache_stats.g.dart';

/// Metadata cache statistics
///
/// Properties:
/// * [metadataFromCache] - Items using existing metadata
/// * [metadataFromTMDB] - Items with fresh TMDB metadata
/// * [totalMetadataFetched] - Total items with metadata
@BuiltValue()
abstract class ApiV1ScanPathPost200ResponseDataCacheStats implements Built<ApiV1ScanPathPost200ResponseDataCacheStats, ApiV1ScanPathPost200ResponseDataCacheStatsBuilder> {
  /// Items using existing metadata
  @BuiltValueField(wireName: r'metadataFromCache')
  num? get metadataFromCache;

  /// Items with fresh TMDB metadata
  @BuiltValueField(wireName: r'metadataFromTMDB')
  num? get metadataFromTMDB;

  /// Total items with metadata
  @BuiltValueField(wireName: r'totalMetadataFetched')
  num? get totalMetadataFetched;

  ApiV1ScanPathPost200ResponseDataCacheStats._();

  factory ApiV1ScanPathPost200ResponseDataCacheStats([void updates(ApiV1ScanPathPost200ResponseDataCacheStatsBuilder b)]) = _$ApiV1ScanPathPost200ResponseDataCacheStats;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1ScanPathPost200ResponseDataCacheStatsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1ScanPathPost200ResponseDataCacheStats> get serializer => _$ApiV1ScanPathPost200ResponseDataCacheStatsSerializer();
}

class _$ApiV1ScanPathPost200ResponseDataCacheStatsSerializer implements PrimitiveSerializer<ApiV1ScanPathPost200ResponseDataCacheStats> {
  @override
  final Iterable<Type> types = const [ApiV1ScanPathPost200ResponseDataCacheStats, _$ApiV1ScanPathPost200ResponseDataCacheStats];

  @override
  final String wireName = r'ApiV1ScanPathPost200ResponseDataCacheStats';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1ScanPathPost200ResponseDataCacheStats object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.metadataFromCache != null) {
      yield r'metadataFromCache';
      yield serializers.serialize(
        object.metadataFromCache,
        specifiedType: const FullType(num),
      );
    }
    if (object.metadataFromTMDB != null) {
      yield r'metadataFromTMDB';
      yield serializers.serialize(
        object.metadataFromTMDB,
        specifiedType: const FullType(num),
      );
    }
    if (object.totalMetadataFetched != null) {
      yield r'totalMetadataFetched';
      yield serializers.serialize(
        object.totalMetadataFetched,
        specifiedType: const FullType(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1ScanPathPost200ResponseDataCacheStats object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1ScanPathPost200ResponseDataCacheStatsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'metadataFromCache':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.metadataFromCache = valueDes;
          break;
        case r'metadataFromTMDB':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.metadataFromTMDB = valueDes;
          break;
        case r'totalMetadataFetched':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.totalMetadataFetched = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1ScanPathPost200ResponseDataCacheStats deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1ScanPathPost200ResponseDataCacheStatsBuilder();
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

