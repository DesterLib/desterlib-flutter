//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_library_delete400_response.g.dart';

/// ApiV1LibraryDelete400Response
///
/// Properties:
/// * [success] 
/// * [error] 
/// * [message] 
@BuiltValue()
abstract class ApiV1LibraryDelete400Response implements Built<ApiV1LibraryDelete400Response, ApiV1LibraryDelete400ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool? get success;

  @BuiltValueField(wireName: r'error')
  String? get error;

  @BuiltValueField(wireName: r'message')
  String? get message;

  ApiV1LibraryDelete400Response._();

  factory ApiV1LibraryDelete400Response([void updates(ApiV1LibraryDelete400ResponseBuilder b)]) = _$ApiV1LibraryDelete400Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1LibraryDelete400ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1LibraryDelete400Response> get serializer => _$ApiV1LibraryDelete400ResponseSerializer();
}

class _$ApiV1LibraryDelete400ResponseSerializer implements PrimitiveSerializer<ApiV1LibraryDelete400Response> {
  @override
  final Iterable<Type> types = const [ApiV1LibraryDelete400Response, _$ApiV1LibraryDelete400Response];

  @override
  final String wireName = r'ApiV1LibraryDelete400Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1LibraryDelete400Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.success != null) {
      yield r'success';
      yield serializers.serialize(
        object.success,
        specifiedType: const FullType(bool),
      );
    }
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
    ApiV1LibraryDelete400Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1LibraryDelete400ResponseBuilder result,
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
  ApiV1LibraryDelete400Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1LibraryDelete400ResponseBuilder();
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

