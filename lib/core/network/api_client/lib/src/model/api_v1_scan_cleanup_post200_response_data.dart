//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_scan_cleanup_post200_response_data.g.dart';

/// ApiV1ScanCleanupPost200ResponseData
///
/// Properties:
/// * [cleanedCount] 
/// * [message] 
@BuiltValue()
abstract class ApiV1ScanCleanupPost200ResponseData implements Built<ApiV1ScanCleanupPost200ResponseData, ApiV1ScanCleanupPost200ResponseDataBuilder> {
  @BuiltValueField(wireName: r'cleanedCount')
  num? get cleanedCount;

  @BuiltValueField(wireName: r'message')
  String? get message;

  ApiV1ScanCleanupPost200ResponseData._();

  factory ApiV1ScanCleanupPost200ResponseData([void updates(ApiV1ScanCleanupPost200ResponseDataBuilder b)]) = _$ApiV1ScanCleanupPost200ResponseData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1ScanCleanupPost200ResponseDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1ScanCleanupPost200ResponseData> get serializer => _$ApiV1ScanCleanupPost200ResponseDataSerializer();
}

class _$ApiV1ScanCleanupPost200ResponseDataSerializer implements PrimitiveSerializer<ApiV1ScanCleanupPost200ResponseData> {
  @override
  final Iterable<Type> types = const [ApiV1ScanCleanupPost200ResponseData, _$ApiV1ScanCleanupPost200ResponseData];

  @override
  final String wireName = r'ApiV1ScanCleanupPost200ResponseData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1ScanCleanupPost200ResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.cleanedCount != null) {
      yield r'cleanedCount';
      yield serializers.serialize(
        object.cleanedCount,
        specifiedType: const FullType(num),
      );
    }
    if (object.message != null) {
      yield r'message';
      yield serializers.serialize(
        object.message,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1ScanCleanupPost200ResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1ScanCleanupPost200ResponseDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cleanedCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.cleanedCount = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1ScanCleanupPost200ResponseData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1ScanCleanupPost200ResponseDataBuilder();
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

