//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/api_v1_scan_path_post200_response_cache_stats.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_scan_path_post200_response.g.dart';

/// ApiV1ScanPathPost200Response
///
/// Properties:
/// * [success] 
/// * [message] 
/// * [libraryId] - The ID of the library that was scanned
/// * [libraryName] - The name of the library
/// * [totalFiles] - Total number of media files discovered during scan
/// * [totalSaved] - Total number of media files successfully saved to the database
/// * [cacheStats] 
@BuiltValue()
abstract class ApiV1ScanPathPost200Response implements Built<ApiV1ScanPathPost200Response, ApiV1ScanPathPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool? get success;

  @BuiltValueField(wireName: r'message')
  String? get message;

  /// The ID of the library that was scanned
  @BuiltValueField(wireName: r'libraryId')
  String? get libraryId;

  /// The name of the library
  @BuiltValueField(wireName: r'libraryName')
  String? get libraryName;

  /// Total number of media files discovered during scan
  @BuiltValueField(wireName: r'totalFiles')
  num? get totalFiles;

  /// Total number of media files successfully saved to the database
  @BuiltValueField(wireName: r'totalSaved')
  num? get totalSaved;

  @BuiltValueField(wireName: r'cacheStats')
  ApiV1ScanPathPost200ResponseCacheStats? get cacheStats;

  ApiV1ScanPathPost200Response._();

  factory ApiV1ScanPathPost200Response([void updates(ApiV1ScanPathPost200ResponseBuilder b)]) = _$ApiV1ScanPathPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1ScanPathPost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1ScanPathPost200Response> get serializer => _$ApiV1ScanPathPost200ResponseSerializer();
}

class _$ApiV1ScanPathPost200ResponseSerializer implements PrimitiveSerializer<ApiV1ScanPathPost200Response> {
  @override
  final Iterable<Type> types = const [ApiV1ScanPathPost200Response, _$ApiV1ScanPathPost200Response];

  @override
  final String wireName = r'ApiV1ScanPathPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1ScanPathPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.success != null) {
      yield r'success';
      yield serializers.serialize(
        object.success,
        specifiedType: const FullType(bool),
      );
    }
    if (object.message != null) {
      yield r'message';
      yield serializers.serialize(
        object.message,
        specifiedType: const FullType(String),
      );
    }
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
        specifiedType: const FullType(ApiV1ScanPathPost200ResponseCacheStats),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1ScanPathPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1ScanPathPost200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'success':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.success = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
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
            specifiedType: const FullType(ApiV1ScanPathPost200ResponseCacheStats),
          ) as ApiV1ScanPathPost200ResponseCacheStats;
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
  ApiV1ScanPathPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1ScanPathPost200ResponseBuilder();
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

