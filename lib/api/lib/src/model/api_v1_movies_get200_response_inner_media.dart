//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_movies_get200_response_inner_media.g.dart';

/// ApiV1MoviesGet200ResponseInnerMedia
///
/// Properties:
/// * [id] 
/// * [title] 
/// * [type] 
/// * [description] 
/// * [posterUrl] 
/// * [backdropUrl] 
/// * [releaseDate] 
/// * [rating] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class ApiV1MoviesGet200ResponseInnerMedia implements Built<ApiV1MoviesGet200ResponseInnerMedia, ApiV1MoviesGet200ResponseInnerMediaBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'title')
  String? get title;

  @BuiltValueField(wireName: r'type')
  ApiV1MoviesGet200ResponseInnerMediaTypeEnum? get type;
  // enum typeEnum {  MOVIE,  TV_SHOW,  MUSIC,  COMIC,  };

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'posterUrl')
  String? get posterUrl;

  @BuiltValueField(wireName: r'backdropUrl')
  String? get backdropUrl;

  @BuiltValueField(wireName: r'releaseDate')
  DateTime? get releaseDate;

  @BuiltValueField(wireName: r'rating')
  num? get rating;

  @BuiltValueField(wireName: r'createdAt')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime? get updatedAt;

  ApiV1MoviesGet200ResponseInnerMedia._();

  factory ApiV1MoviesGet200ResponseInnerMedia([void updates(ApiV1MoviesGet200ResponseInnerMediaBuilder b)]) = _$ApiV1MoviesGet200ResponseInnerMedia;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1MoviesGet200ResponseInnerMediaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1MoviesGet200ResponseInnerMedia> get serializer => _$ApiV1MoviesGet200ResponseInnerMediaSerializer();
}

class _$ApiV1MoviesGet200ResponseInnerMediaSerializer implements PrimitiveSerializer<ApiV1MoviesGet200ResponseInnerMedia> {
  @override
  final Iterable<Type> types = const [ApiV1MoviesGet200ResponseInnerMedia, _$ApiV1MoviesGet200ResponseInnerMedia];

  @override
  final String wireName = r'ApiV1MoviesGet200ResponseInnerMedia';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1MoviesGet200ResponseInnerMedia object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      );
    }
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(ApiV1MoviesGet200ResponseInnerMediaTypeEnum),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.posterUrl != null) {
      yield r'posterUrl';
      yield serializers.serialize(
        object.posterUrl,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.backdropUrl != null) {
      yield r'backdropUrl';
      yield serializers.serialize(
        object.backdropUrl,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.releaseDate != null) {
      yield r'releaseDate';
      yield serializers.serialize(
        object.releaseDate,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.rating != null) {
      yield r'rating';
      yield serializers.serialize(
        object.rating,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.createdAt != null) {
      yield r'createdAt';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.updatedAt != null) {
      yield r'updatedAt';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1MoviesGet200ResponseInnerMedia object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1MoviesGet200ResponseInnerMediaBuilder result,
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
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1MoviesGet200ResponseInnerMediaTypeEnum),
          ) as ApiV1MoviesGet200ResponseInnerMediaTypeEnum;
          result.type = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'posterUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.posterUrl = valueDes;
          break;
        case r'backdropUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.backdropUrl = valueDes;
          break;
        case r'releaseDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.releaseDate = valueDes;
          break;
        case r'rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.rating = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1MoviesGet200ResponseInnerMedia deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1MoviesGet200ResponseInnerMediaBuilder();
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

class ApiV1MoviesGet200ResponseInnerMediaTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MOVIE')
  static const ApiV1MoviesGet200ResponseInnerMediaTypeEnum MOVIE = _$apiV1MoviesGet200ResponseInnerMediaTypeEnum_MOVIE;
  @BuiltValueEnumConst(wireName: r'TV_SHOW')
  static const ApiV1MoviesGet200ResponseInnerMediaTypeEnum TV_SHOW = _$apiV1MoviesGet200ResponseInnerMediaTypeEnum_TV_SHOW;
  @BuiltValueEnumConst(wireName: r'MUSIC')
  static const ApiV1MoviesGet200ResponseInnerMediaTypeEnum MUSIC = _$apiV1MoviesGet200ResponseInnerMediaTypeEnum_MUSIC;
  @BuiltValueEnumConst(wireName: r'COMIC')
  static const ApiV1MoviesGet200ResponseInnerMediaTypeEnum COMIC = _$apiV1MoviesGet200ResponseInnerMediaTypeEnum_COMIC;

  static Serializer<ApiV1MoviesGet200ResponseInnerMediaTypeEnum> get serializer => _$apiV1MoviesGet200ResponseInnerMediaTypeEnumSerializer;

  const ApiV1MoviesGet200ResponseInnerMediaTypeEnum._(String name): super(name);

  static BuiltSet<ApiV1MoviesGet200ResponseInnerMediaTypeEnum> get values => _$apiV1MoviesGet200ResponseInnerMediaTypeEnumValues;
  static ApiV1MoviesGet200ResponseInnerMediaTypeEnum valueOf(String name) => _$apiV1MoviesGet200ResponseInnerMediaTypeEnumValueOf(name);
}

