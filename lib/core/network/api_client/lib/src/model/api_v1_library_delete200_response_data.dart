//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_library_delete200_response_data.g.dart';

/// ApiV1LibraryDelete200ResponseData
///
/// Properties:
/// * [libraryId] 
/// * [libraryName] 
/// * [mediaDeleted] - Number of media entries deleted
/// * [message] 
@BuiltValue()
abstract class ApiV1LibraryDelete200ResponseData implements Built<ApiV1LibraryDelete200ResponseData, ApiV1LibraryDelete200ResponseDataBuilder> {
  @BuiltValueField(wireName: r'libraryId')
  String? get libraryId;

  @BuiltValueField(wireName: r'libraryName')
  String? get libraryName;

  /// Number of media entries deleted
  @BuiltValueField(wireName: r'mediaDeleted')
  num? get mediaDeleted;

  @BuiltValueField(wireName: r'message')
  String? get message;

  ApiV1LibraryDelete200ResponseData._();

  factory ApiV1LibraryDelete200ResponseData([void updates(ApiV1LibraryDelete200ResponseDataBuilder b)]) = _$ApiV1LibraryDelete200ResponseData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1LibraryDelete200ResponseDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1LibraryDelete200ResponseData> get serializer => _$ApiV1LibraryDelete200ResponseDataSerializer();
}

class _$ApiV1LibraryDelete200ResponseDataSerializer implements PrimitiveSerializer<ApiV1LibraryDelete200ResponseData> {
  @override
  final Iterable<Type> types = const [ApiV1LibraryDelete200ResponseData, _$ApiV1LibraryDelete200ResponseData];

  @override
  final String wireName = r'ApiV1LibraryDelete200ResponseData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1LibraryDelete200ResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    ApiV1LibraryDelete200ResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1LibraryDelete200ResponseDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  ApiV1LibraryDelete200ResponseData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1LibraryDelete200ResponseDataBuilder();
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

