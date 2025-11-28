//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_scan_path_post202_response_data.g.dart';

/// ApiV1ScanPathPost202ResponseData
///
/// Properties:
/// * [path] 
/// * [mediaType] 
/// * [queued] - Whether the scan was queued (true) or started immediately (false)
/// * [queuePosition] - Position in queue (only present if queued is true)
@BuiltValue()
abstract class ApiV1ScanPathPost202ResponseData implements Built<ApiV1ScanPathPost202ResponseData, ApiV1ScanPathPost202ResponseDataBuilder> {
  @BuiltValueField(wireName: r'path')
  String? get path;

  @BuiltValueField(wireName: r'mediaType')
  String? get mediaType;

  /// Whether the scan was queued (true) or started immediately (false)
  @BuiltValueField(wireName: r'queued')
  bool? get queued;

  /// Position in queue (only present if queued is true)
  @BuiltValueField(wireName: r'queuePosition')
  num? get queuePosition;

  ApiV1ScanPathPost202ResponseData._();

  factory ApiV1ScanPathPost202ResponseData([void updates(ApiV1ScanPathPost202ResponseDataBuilder b)]) = _$ApiV1ScanPathPost202ResponseData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1ScanPathPost202ResponseDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1ScanPathPost202ResponseData> get serializer => _$ApiV1ScanPathPost202ResponseDataSerializer();
}

class _$ApiV1ScanPathPost202ResponseDataSerializer implements PrimitiveSerializer<ApiV1ScanPathPost202ResponseData> {
  @override
  final Iterable<Type> types = const [ApiV1ScanPathPost202ResponseData, _$ApiV1ScanPathPost202ResponseData];

  @override
  final String wireName = r'ApiV1ScanPathPost202ResponseData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1ScanPathPost202ResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.path != null) {
      yield r'path';
      yield serializers.serialize(
        object.path,
        specifiedType: const FullType(String),
      );
    }
    if (object.mediaType != null) {
      yield r'mediaType';
      yield serializers.serialize(
        object.mediaType,
        specifiedType: const FullType(String),
      );
    }
    if (object.queued != null) {
      yield r'queued';
      yield serializers.serialize(
        object.queued,
        specifiedType: const FullType(bool),
      );
    }
    if (object.queuePosition != null) {
      yield r'queuePosition';
      yield serializers.serialize(
        object.queuePosition,
        specifiedType: const FullType(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1ScanPathPost202ResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1ScanPathPost202ResponseDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.path = valueDes;
          break;
        case r'mediaType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mediaType = valueDes;
          break;
        case r'queued':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.queued = valueDes;
          break;
        case r'queuePosition':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.queuePosition = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1ScanPathPost202ResponseData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1ScanPathPost202ResponseDataBuilder();
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

