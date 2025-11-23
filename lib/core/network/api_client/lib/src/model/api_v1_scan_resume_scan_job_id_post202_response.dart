//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
// External packages
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:openapi/src/model/api_v1_scan_resume_scan_job_id_post202_response_data.dart';


part 'api_v1_scan_resume_scan_job_id_post202_response.g.dart';

/// ApiV1ScanResumeScanJobIdPost202Response
///
/// Properties:
/// * [success] 
/// * [message] 
/// * [data] 
@BuiltValue()
abstract class ApiV1ScanResumeScanJobIdPost202Response implements Built<ApiV1ScanResumeScanJobIdPost202Response, ApiV1ScanResumeScanJobIdPost202ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool? get success;

  @BuiltValueField(wireName: r'message')
  String? get message;

  @BuiltValueField(wireName: r'data')
  ApiV1ScanResumeScanJobIdPost202ResponseData? get data;

  ApiV1ScanResumeScanJobIdPost202Response._();

  factory ApiV1ScanResumeScanJobIdPost202Response([void updates(ApiV1ScanResumeScanJobIdPost202ResponseBuilder b)]) = _$ApiV1ScanResumeScanJobIdPost202Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1ScanResumeScanJobIdPost202ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1ScanResumeScanJobIdPost202Response> get serializer => _$ApiV1ScanResumeScanJobIdPost202ResponseSerializer();
}

class _$ApiV1ScanResumeScanJobIdPost202ResponseSerializer implements PrimitiveSerializer<ApiV1ScanResumeScanJobIdPost202Response> {
  @override
  final Iterable<Type> types = const [ApiV1ScanResumeScanJobIdPost202Response, _$ApiV1ScanResumeScanJobIdPost202Response];

  @override
  final String wireName = r'ApiV1ScanResumeScanJobIdPost202Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1ScanResumeScanJobIdPost202Response object, {
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
    if (object.data != null) {
      yield r'data';
      yield serializers.serialize(
        object.data,
        specifiedType: const FullType(ApiV1ScanResumeScanJobIdPost202ResponseData),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1ScanResumeScanJobIdPost202Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1ScanResumeScanJobIdPost202ResponseBuilder result,
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
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1ScanResumeScanJobIdPost202ResponseData),
          ) as ApiV1ScanResumeScanJobIdPost202ResponseData;
          result.data.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1ScanResumeScanJobIdPost202Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1ScanResumeScanJobIdPost202ResponseBuilder();
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

