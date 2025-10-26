//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_scan_path_post500_response.g.dart';

/// ApiV1ScanPathPost500Response
///
/// Properties:
/// * [error] 
/// * [message] 
@BuiltValue()
abstract class ApiV1ScanPathPost500Response implements Built<ApiV1ScanPathPost500Response, ApiV1ScanPathPost500ResponseBuilder> {
  @BuiltValueField(wireName: r'error')
  String? get error;

  @BuiltValueField(wireName: r'message')
  String? get message;

  ApiV1ScanPathPost500Response._();

  factory ApiV1ScanPathPost500Response([void updates(ApiV1ScanPathPost500ResponseBuilder b)]) = _$ApiV1ScanPathPost500Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1ScanPathPost500ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1ScanPathPost500Response> get serializer => _$ApiV1ScanPathPost500ResponseSerializer();
}

class _$ApiV1ScanPathPost500ResponseSerializer implements PrimitiveSerializer<ApiV1ScanPathPost500Response> {
  @override
  final Iterable<Type> types = const [ApiV1ScanPathPost500Response, _$ApiV1ScanPathPost500Response];

  @override
  final String wireName = r'ApiV1ScanPathPost500Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1ScanPathPost500Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.error != null) {
      yield r'error';
      yield serializers.serialize(
        object.error,
        specifiedType: const FullType(String),
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
    ApiV1ScanPathPost500Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1ScanPathPost500ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.error = valueDes;
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
  ApiV1ScanPathPost500Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1ScanPathPost500ResponseBuilder();
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

