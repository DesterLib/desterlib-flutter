//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_movies_get200_response.g.dart';

/// ApiV1MoviesGet200Response
///
/// Properties:
/// * [success] 
/// * [data] 
/// * [properties] 
@BuiltValue()
abstract class ApiV1MoviesGet200Response implements Built<ApiV1MoviesGet200Response, ApiV1MoviesGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool? get success;

  @BuiltValueField(wireName: r'data')
  BuiltList<String>? get data;

  @BuiltValueField(wireName: r'properties')
  JsonObject? get properties;

  ApiV1MoviesGet200Response._();

  factory ApiV1MoviesGet200Response([void updates(ApiV1MoviesGet200ResponseBuilder b)]) = _$ApiV1MoviesGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1MoviesGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1MoviesGet200Response> get serializer => _$ApiV1MoviesGet200ResponseSerializer();
}

class _$ApiV1MoviesGet200ResponseSerializer implements PrimitiveSerializer<ApiV1MoviesGet200Response> {
  @override
  final Iterable<Type> types = const [ApiV1MoviesGet200Response, _$ApiV1MoviesGet200Response];

  @override
  final String wireName = r'ApiV1MoviesGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1MoviesGet200Response object, {
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
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.properties != null) {
      yield r'properties';
      yield serializers.serialize(
        object.properties,
        specifiedType: const FullType.nullable(JsonObject),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1MoviesGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1MoviesGet200ResponseBuilder result,
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
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.data.replace(valueDes);
          break;
        case r'properties':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.properties = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1MoviesGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1MoviesGet200ResponseBuilder();
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

