//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
// External packages
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:openapi/src/model/model_library.dart';


part 'api_v1_library_get200_response.g.dart';

/// ApiV1LibraryGet200Response
///
/// Properties:
/// * [success] 
/// * [data] 
@BuiltValue()
abstract class ApiV1LibraryGet200Response implements Built<ApiV1LibraryGet200Response, ApiV1LibraryGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool? get success;

  @BuiltValueField(wireName: r'data')
  BuiltList<ModelLibrary>? get data;

  ApiV1LibraryGet200Response._();

  factory ApiV1LibraryGet200Response([void updates(ApiV1LibraryGet200ResponseBuilder b)]) = _$ApiV1LibraryGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1LibraryGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1LibraryGet200Response> get serializer => _$ApiV1LibraryGet200ResponseSerializer();
}

class _$ApiV1LibraryGet200ResponseSerializer implements PrimitiveSerializer<ApiV1LibraryGet200Response> {
  @override
  final Iterable<Type> types = const [ApiV1LibraryGet200Response, _$ApiV1LibraryGet200Response];

  @override
  final String wireName = r'ApiV1LibraryGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1LibraryGet200Response object, {
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
        specifiedType: const FullType(BuiltList, [FullType(ModelLibrary)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1LibraryGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1LibraryGet200ResponseBuilder result,
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
            specifiedType: const FullType(BuiltList, [FullType(ModelLibrary)]),
          ) as BuiltList<ModelLibrary>;
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
  ApiV1LibraryGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1LibraryGet200ResponseBuilder();
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

