//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
// External packages
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';


part 'api_v1_library_put_request.g.dart';

/// ApiV1LibraryPutRequest
///
/// Properties:
/// * [id] - The ID of the library to update
/// * [name] - Updated library name
/// * [description] - Updated library description
/// * [posterUrl] - Updated poster image URL
/// * [backdropUrl] - Updated backdrop image URL
/// * [libraryPath] - Updated file system path
/// * [libraryType] - Updated library media type
@BuiltValue()
abstract class ApiV1LibraryPutRequest implements Built<ApiV1LibraryPutRequest, ApiV1LibraryPutRequestBuilder> {
  /// The ID of the library to update
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Updated library name
  @BuiltValueField(wireName: r'name')
  String? get name;

  /// Updated library description
  @BuiltValueField(wireName: r'description')
  String? get description;

  /// Updated poster image URL
  @BuiltValueField(wireName: r'posterUrl')
  String? get posterUrl;

  /// Updated backdrop image URL
  @BuiltValueField(wireName: r'backdropUrl')
  String? get backdropUrl;

  /// Updated file system path
  @BuiltValueField(wireName: r'libraryPath')
  String? get libraryPath;

  /// Updated library media type
  @BuiltValueField(wireName: r'libraryType')
  ApiV1LibraryPutRequestLibraryTypeEnum? get libraryType;
  // enum libraryTypeEnum {  MOVIE,  TV_SHOW,  MUSIC,  COMIC,  };

  ApiV1LibraryPutRequest._();

  factory ApiV1LibraryPutRequest([void updates(ApiV1LibraryPutRequestBuilder b)]) = _$ApiV1LibraryPutRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1LibraryPutRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1LibraryPutRequest> get serializer => _$ApiV1LibraryPutRequestSerializer();
}

class _$ApiV1LibraryPutRequestSerializer implements PrimitiveSerializer<ApiV1LibraryPutRequest> {
  @override
  final Iterable<Type> types = const [ApiV1LibraryPutRequest, _$ApiV1LibraryPutRequest];

  @override
  final String wireName = r'ApiV1LibraryPutRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1LibraryPutRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    if (object.posterUrl != null) {
      yield r'posterUrl';
      yield serializers.serialize(
        object.posterUrl,
        specifiedType: const FullType(String),
      );
    }
    if (object.backdropUrl != null) {
      yield r'backdropUrl';
      yield serializers.serialize(
        object.backdropUrl,
        specifiedType: const FullType(String),
      );
    }
    if (object.libraryPath != null) {
      yield r'libraryPath';
      yield serializers.serialize(
        object.libraryPath,
        specifiedType: const FullType(String),
      );
    }
    if (object.libraryType != null) {
      yield r'libraryType';
      yield serializers.serialize(
        object.libraryType,
        specifiedType: const FullType(ApiV1LibraryPutRequestLibraryTypeEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1LibraryPutRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1LibraryPutRequestBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'posterUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.posterUrl = valueDes;
          break;
        case r'backdropUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.backdropUrl = valueDes;
          break;
        case r'libraryPath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.libraryPath = valueDes;
          break;
        case r'libraryType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1LibraryPutRequestLibraryTypeEnum),
          ) as ApiV1LibraryPutRequestLibraryTypeEnum;
          result.libraryType = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1LibraryPutRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1LibraryPutRequestBuilder();
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

class ApiV1LibraryPutRequestLibraryTypeEnum extends EnumClass {

  /// Updated library media type
  @BuiltValueEnumConst(wireName: r'MOVIE')
  static const ApiV1LibraryPutRequestLibraryTypeEnum MOVIE = _$apiV1LibraryPutRequestLibraryTypeEnum_MOVIE;
  /// Updated library media type
  @BuiltValueEnumConst(wireName: r'TV_SHOW')
  static const ApiV1LibraryPutRequestLibraryTypeEnum TV_SHOW = _$apiV1LibraryPutRequestLibraryTypeEnum_TV_SHOW;
  /// Updated library media type
  @BuiltValueEnumConst(wireName: r'MUSIC')
  static const ApiV1LibraryPutRequestLibraryTypeEnum MUSIC = _$apiV1LibraryPutRequestLibraryTypeEnum_MUSIC;
  /// Updated library media type
  @BuiltValueEnumConst(wireName: r'COMIC')
  static const ApiV1LibraryPutRequestLibraryTypeEnum COMIC = _$apiV1LibraryPutRequestLibraryTypeEnum_COMIC;

  static Serializer<ApiV1LibraryPutRequestLibraryTypeEnum> get serializer => _$apiV1LibraryPutRequestLibraryTypeEnumSerializer;

  const ApiV1LibraryPutRequestLibraryTypeEnum._(String name): super(name);

  static BuiltSet<ApiV1LibraryPutRequestLibraryTypeEnum> get values => _$apiV1LibraryPutRequestLibraryTypeEnumValues;
  static ApiV1LibraryPutRequestLibraryTypeEnum valueOf(String name) => _$apiV1LibraryPutRequestLibraryTypeEnumValueOf(name);
}

