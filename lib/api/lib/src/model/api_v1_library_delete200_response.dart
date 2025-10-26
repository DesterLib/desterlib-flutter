//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_library_delete200_response.g.dart';

/// ApiV1LibraryDelete200Response
///
/// Properties:
/// * [success] 
/// * [libraryId] 
/// * [libraryName] 
/// * [mediaDeleted] - Number of media entries that were deleted (only those belonging exclusively to this library)
/// * [message] 
@BuiltValue()
abstract class ApiV1LibraryDelete200Response implements Built<ApiV1LibraryDelete200Response, ApiV1LibraryDelete200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool? get success;

  @BuiltValueField(wireName: r'libraryId')
  String? get libraryId;

  @BuiltValueField(wireName: r'libraryName')
  String? get libraryName;

  /// Number of media entries that were deleted (only those belonging exclusively to this library)
  @BuiltValueField(wireName: r'mediaDeleted')
  num? get mediaDeleted;

  @BuiltValueField(wireName: r'message')
  String? get message;

  ApiV1LibraryDelete200Response._();

  factory ApiV1LibraryDelete200Response([void updates(ApiV1LibraryDelete200ResponseBuilder b)]) = _$ApiV1LibraryDelete200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1LibraryDelete200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1LibraryDelete200Response> get serializer => _$ApiV1LibraryDelete200ResponseSerializer();
}

class _$ApiV1LibraryDelete200ResponseSerializer implements PrimitiveSerializer<ApiV1LibraryDelete200Response> {
  @override
  final Iterable<Type> types = const [ApiV1LibraryDelete200Response, _$ApiV1LibraryDelete200Response];

  @override
  final String wireName = r'ApiV1LibraryDelete200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1LibraryDelete200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.success != null) {
      yield r'success';
      yield serializers.serialize(
        object.success,
        specifiedType: const FullType(bool),
      );
    }
    if (object.libraryId != null) {
      yield r'libraryId';
      yield serializers.serialize(
        object.libraryId,
        specifiedType: const FullType(String),
      );
    }
    if (object.libraryName != null) {
      yield r'libraryName';
      yield serializers.serialize(
        object.libraryName,
        specifiedType: const FullType(String),
      );
    }
    if (object.mediaDeleted != null) {
      yield r'mediaDeleted';
      yield serializers.serialize(
        object.mediaDeleted,
        specifiedType: const FullType(num),
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
    ApiV1LibraryDelete200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1LibraryDelete200ResponseBuilder result,
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
        case r'libraryId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.libraryId = valueDes;
          break;
        case r'libraryName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.libraryName = valueDes;
          break;
        case r'mediaDeleted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.mediaDeleted = valueDes;
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
  ApiV1LibraryDelete200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1LibraryDelete200ResponseBuilder();
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

