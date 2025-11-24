//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_movies_id_get200_response_data_media.g.dart';

/// ApiV1MoviesIdGet200ResponseDataMedia
///
/// Properties:
/// * [id] 
/// * [title] 
/// * [type] 
/// * [description] 
/// * [posterUrl] 
/// * [backdropUrl] 
/// * [meshGradientColors] - Hex color strings for mesh gradient (4 corners)
/// * [releaseDate] 
/// * [rating] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class ApiV1MoviesIdGet200ResponseDataMedia implements Built<ApiV1MoviesIdGet200ResponseDataMedia, ApiV1MoviesIdGet200ResponseDataMediaBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'title')
  String? get title;

  @BuiltValueField(wireName: r'type')
  ApiV1MoviesIdGet200ResponseDataMediaTypeEnum? get type;
  // enum typeEnum {  MOVIE,  TV_SHOW,  MUSIC,  COMIC,  };

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'posterUrl')
  String? get posterUrl;

  @BuiltValueField(wireName: r'backdropUrl')
  String? get backdropUrl;

  /// Hex color strings for mesh gradient (4 corners)
  @BuiltValueField(wireName: r'meshGradientColors')
  BuiltList<String>? get meshGradientColors;

  @BuiltValueField(wireName: r'releaseDate')
  DateTime? get releaseDate;

  @BuiltValueField(wireName: r'rating')
  num? get rating;

  @BuiltValueField(wireName: r'createdAt')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime? get updatedAt;

  ApiV1MoviesIdGet200ResponseDataMedia._();

  factory ApiV1MoviesIdGet200ResponseDataMedia([void updates(ApiV1MoviesIdGet200ResponseDataMediaBuilder b)]) = _$ApiV1MoviesIdGet200ResponseDataMedia;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1MoviesIdGet200ResponseDataMediaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1MoviesIdGet200ResponseDataMedia> get serializer => _$ApiV1MoviesIdGet200ResponseDataMediaSerializer();
}

class _$ApiV1MoviesIdGet200ResponseDataMediaSerializer implements PrimitiveSerializer<ApiV1MoviesIdGet200ResponseDataMedia> {
  @override
  final Iterable<Type> types = const [ApiV1MoviesIdGet200ResponseDataMedia, _$ApiV1MoviesIdGet200ResponseDataMedia];

  @override
  final String wireName = r'ApiV1MoviesIdGet200ResponseDataMedia';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1MoviesIdGet200ResponseDataMedia object, {
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
        specifiedType: const FullType(ApiV1MoviesIdGet200ResponseDataMediaTypeEnum),
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
    if (object.meshGradientColors != null) {
      yield r'meshGradientColors';
      yield serializers.serialize(
        object.meshGradientColors,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
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
    ApiV1MoviesIdGet200ResponseDataMedia object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1MoviesIdGet200ResponseDataMediaBuilder result,
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
            specifiedType: const FullType(ApiV1MoviesIdGet200ResponseDataMediaTypeEnum),
          ) as ApiV1MoviesIdGet200ResponseDataMediaTypeEnum;
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
        case r'meshGradientColors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.meshGradientColors.replace(valueDes);
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
  ApiV1MoviesIdGet200ResponseDataMedia deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1MoviesIdGet200ResponseDataMediaBuilder();
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

class ApiV1MoviesIdGet200ResponseDataMediaTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MOVIE')
  static const ApiV1MoviesIdGet200ResponseDataMediaTypeEnum MOVIE = _$apiV1MoviesIdGet200ResponseDataMediaTypeEnum_MOVIE;
  @BuiltValueEnumConst(wireName: r'TV_SHOW')
  static const ApiV1MoviesIdGet200ResponseDataMediaTypeEnum TV_SHOW = _$apiV1MoviesIdGet200ResponseDataMediaTypeEnum_TV_SHOW;
  @BuiltValueEnumConst(wireName: r'MUSIC')
  static const ApiV1MoviesIdGet200ResponseDataMediaTypeEnum MUSIC = _$apiV1MoviesIdGet200ResponseDataMediaTypeEnum_MUSIC;
  @BuiltValueEnumConst(wireName: r'COMIC')
  static const ApiV1MoviesIdGet200ResponseDataMediaTypeEnum COMIC = _$apiV1MoviesIdGet200ResponseDataMediaTypeEnum_COMIC;

  static Serializer<ApiV1MoviesIdGet200ResponseDataMediaTypeEnum> get serializer => _$apiV1MoviesIdGet200ResponseDataMediaTypeEnumSerializer;

  const ApiV1MoviesIdGet200ResponseDataMediaTypeEnum._(String name): super(name);

  static BuiltSet<ApiV1MoviesIdGet200ResponseDataMediaTypeEnum> get values => _$apiV1MoviesIdGet200ResponseDataMediaTypeEnumValues;
  static ApiV1MoviesIdGet200ResponseDataMediaTypeEnum valueOf(String name) => _$apiV1MoviesIdGet200ResponseDataMediaTypeEnumValueOf(name);
}

