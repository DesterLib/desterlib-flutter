//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/model_library.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_library_put200_response_data.g.dart';

/// ApiV1LibraryPut200ResponseData
///
/// Properties:
/// * [library_] 
/// * [message] 
@BuiltValue()
abstract class ApiV1LibraryPut200ResponseData implements Built<ApiV1LibraryPut200ResponseData, ApiV1LibraryPut200ResponseDataBuilder> {
  @BuiltValueField(wireName: r'library')
  ModelLibrary? get library_;

  @BuiltValueField(wireName: r'message')
  String? get message;

  ApiV1LibraryPut200ResponseData._();

  factory ApiV1LibraryPut200ResponseData([void updates(ApiV1LibraryPut200ResponseDataBuilder b)]) = _$ApiV1LibraryPut200ResponseData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1LibraryPut200ResponseDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1LibraryPut200ResponseData> get serializer => _$ApiV1LibraryPut200ResponseDataSerializer();
}

class _$ApiV1LibraryPut200ResponseDataSerializer implements PrimitiveSerializer<ApiV1LibraryPut200ResponseData> {
  @override
  final Iterable<Type> types = const [ApiV1LibraryPut200ResponseData, _$ApiV1LibraryPut200ResponseData];

  @override
  final String wireName = r'ApiV1LibraryPut200ResponseData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1LibraryPut200ResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.library_ != null) {
      yield r'library';
      yield serializers.serialize(
        object.library_,
        specifiedType: const FullType(ModelLibrary),
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
    ApiV1LibraryPut200ResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1LibraryPut200ResponseDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'library':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ModelLibrary),
          ) as ModelLibrary;
          result.library_.replace(valueDes);
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
  ApiV1LibraryPut200ResponseData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1LibraryPut200ResponseDataBuilder();
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

