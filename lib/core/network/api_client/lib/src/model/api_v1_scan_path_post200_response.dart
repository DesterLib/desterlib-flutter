//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
// External packages
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:openapi/src/model/api_v1_scan_path_post200_response_data.dart';


part 'api_v1_scan_path_post200_response.g.dart';

/// ApiV1ScanPathPost200Response
///
/// Properties:
/// * [success] 
/// * [data] 
/// * [message] 
@BuiltValue()
abstract class ApiV1ScanPathPost200Response implements Built<ApiV1ScanPathPost200Response, ApiV1ScanPathPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool? get success;

  @BuiltValueField(wireName: r'data')
  ApiV1ScanPathPost200ResponseData? get data;

  @BuiltValueField(wireName: r'message')
  String? get message;

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
    if (object.data != null) {
      yield r'data';
      yield serializers.serialize(
        object.data,
        specifiedType: const FullType(ApiV1ScanPathPost200ResponseData),
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
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1ScanPathPost200ResponseData),
          ) as ApiV1ScanPathPost200ResponseData;
          result.data.replace(valueDes);
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

