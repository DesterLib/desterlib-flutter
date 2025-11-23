//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
// External packages
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';


part 'api_v1_library_delete_request.g.dart';

/// ApiV1LibraryDeleteRequest
///
/// Properties:
/// * [id] - The ID of the library to delete
@BuiltValue()
abstract class ApiV1LibraryDeleteRequest implements Built<ApiV1LibraryDeleteRequest, ApiV1LibraryDeleteRequestBuilder> {
  /// The ID of the library to delete
  @BuiltValueField(wireName: r'id')
  String get id;

  ApiV1LibraryDeleteRequest._();

  factory ApiV1LibraryDeleteRequest([void updates(ApiV1LibraryDeleteRequestBuilder b)]) = _$ApiV1LibraryDeleteRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1LibraryDeleteRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1LibraryDeleteRequest> get serializer => _$ApiV1LibraryDeleteRequestSerializer();
}

class _$ApiV1LibraryDeleteRequestSerializer implements PrimitiveSerializer<ApiV1LibraryDeleteRequest> {
  @override
  final Iterable<Type> types = const [ApiV1LibraryDeleteRequest, _$ApiV1LibraryDeleteRequest];

  @override
  final String wireName = r'ApiV1LibraryDeleteRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1LibraryDeleteRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1LibraryDeleteRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1LibraryDeleteRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1LibraryDeleteRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1LibraryDeleteRequestBuilder();
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

