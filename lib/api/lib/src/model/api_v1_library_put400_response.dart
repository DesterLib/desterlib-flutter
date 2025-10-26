//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_library_put400_response.g.dart';

/// ApiV1LibraryPut400Response
///
/// Properties:
/// * [error] 
@BuiltValue()
abstract class ApiV1LibraryPut400Response implements Built<ApiV1LibraryPut400Response, ApiV1LibraryPut400ResponseBuilder> {
  @BuiltValueField(wireName: r'error')
  String? get error;

  ApiV1LibraryPut400Response._();

  factory ApiV1LibraryPut400Response([void updates(ApiV1LibraryPut400ResponseBuilder b)]) = _$ApiV1LibraryPut400Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1LibraryPut400ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1LibraryPut400Response> get serializer => _$ApiV1LibraryPut400ResponseSerializer();
}

class _$ApiV1LibraryPut400ResponseSerializer implements PrimitiveSerializer<ApiV1LibraryPut400Response> {
  @override
  final Iterable<Type> types = const [ApiV1LibraryPut400Response, _$ApiV1LibraryPut400Response];

  @override
  final String wireName = r'ApiV1LibraryPut400Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1LibraryPut400Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.error != null) {
      yield r'error';
      yield serializers.serialize(
        object.error,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1LibraryPut400Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1LibraryPut400ResponseBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1LibraryPut400Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1LibraryPut400ResponseBuilder();
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

