//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
// External packages
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';


part 'api_v1_scan_resume_scan_job_id_post202_response_data.g.dart';

/// ApiV1ScanResumeScanJobIdPost202ResponseData
///
/// Properties:
/// * [scanJobId] 
@BuiltValue()
abstract class ApiV1ScanResumeScanJobIdPost202ResponseData implements Built<ApiV1ScanResumeScanJobIdPost202ResponseData, ApiV1ScanResumeScanJobIdPost202ResponseDataBuilder> {
  @BuiltValueField(wireName: r'scanJobId')
  String? get scanJobId;

  ApiV1ScanResumeScanJobIdPost202ResponseData._();

  factory ApiV1ScanResumeScanJobIdPost202ResponseData([void updates(ApiV1ScanResumeScanJobIdPost202ResponseDataBuilder b)]) = _$ApiV1ScanResumeScanJobIdPost202ResponseData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1ScanResumeScanJobIdPost202ResponseDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1ScanResumeScanJobIdPost202ResponseData> get serializer => _$ApiV1ScanResumeScanJobIdPost202ResponseDataSerializer();
}

class _$ApiV1ScanResumeScanJobIdPost202ResponseDataSerializer implements PrimitiveSerializer<ApiV1ScanResumeScanJobIdPost202ResponseData> {
  @override
  final Iterable<Type> types = const [ApiV1ScanResumeScanJobIdPost202ResponseData, _$ApiV1ScanResumeScanJobIdPost202ResponseData];

  @override
  final String wireName = r'ApiV1ScanResumeScanJobIdPost202ResponseData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1ScanResumeScanJobIdPost202ResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.scanJobId != null) {
      yield r'scanJobId';
      yield serializers.serialize(
        object.scanJobId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1ScanResumeScanJobIdPost202ResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1ScanResumeScanJobIdPost202ResponseDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'scanJobId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.scanJobId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1ScanResumeScanJobIdPost202ResponseData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1ScanResumeScanJobIdPost202ResponseDataBuilder();
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

