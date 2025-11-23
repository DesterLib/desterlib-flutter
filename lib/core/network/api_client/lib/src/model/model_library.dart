//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
// External packages
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';


part 'model_library.g.dart';

/// ModelLibrary
///
/// Properties:
/// * [id] - Unique library identifier
/// * [name] - Library name
/// * [slug] - URL-friendly library identifier
/// * [description] - Library description
/// * [posterUrl] - URL to the library poster image
/// * [backdropUrl] - URL to the library backdrop image
/// * [isLibrary] - Whether this is a library (true) or collection (false)
/// * [libraryPath] - File system path to the library
/// * [libraryType] - Type of media in the library
/// * [createdAt] - Library creation timestamp
/// * [updatedAt] - Library last update timestamp
/// * [parentId] - ID of parent library (for nested libraries)
/// * [mediaCount] - Number of media items in the library
@BuiltValue()
abstract class ModelLibrary implements Built<ModelLibrary, ModelLibraryBuilder> {
  /// Unique library identifier
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Library name
  @BuiltValueField(wireName: r'name')
  String get name;

  /// URL-friendly library identifier
  @BuiltValueField(wireName: r'slug')
  String get slug;

  /// Library description
  @BuiltValueField(wireName: r'description')
  String? get description;

  /// URL to the library poster image
  @BuiltValueField(wireName: r'posterUrl')
  String? get posterUrl;

  /// URL to the library backdrop image
  @BuiltValueField(wireName: r'backdropUrl')
  String? get backdropUrl;

  /// Whether this is a library (true) or collection (false)
  @BuiltValueField(wireName: r'isLibrary')
  bool get isLibrary;

  /// File system path to the library
  @BuiltValueField(wireName: r'libraryPath')
  String? get libraryPath;

  /// Type of media in the library
  @BuiltValueField(wireName: r'libraryType')
  ModelLibraryLibraryTypeEnum? get libraryType;
  // enum libraryTypeEnum {  MOVIE,  TV_SHOW,  MUSIC,  COMIC,  };

  /// Library creation timestamp
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Library last update timestamp
  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  /// ID of parent library (for nested libraries)
  @BuiltValueField(wireName: r'parentId')
  String? get parentId;

  /// Number of media items in the library
  @BuiltValueField(wireName: r'mediaCount')
  num? get mediaCount;

  ModelLibrary._();

  factory ModelLibrary([void updates(ModelLibraryBuilder b)]) = _$ModelLibrary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ModelLibraryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ModelLibrary> get serializer => _$ModelLibrarySerializer();
}

class _$ModelLibrarySerializer implements PrimitiveSerializer<ModelLibrary> {
  @override
  final Iterable<Type> types = const [ModelLibrary, _$ModelLibrary];

  @override
  final String wireName = r'ModelLibrary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ModelLibrary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'slug';
    yield serializers.serialize(
      object.slug,
      specifiedType: const FullType(String),
    );
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
    yield r'isLibrary';
    yield serializers.serialize(
      object.isLibrary,
      specifiedType: const FullType(bool),
    );
    if (object.libraryPath != null) {
      yield r'libraryPath';
      yield serializers.serialize(
        object.libraryPath,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.libraryType != null) {
      yield r'libraryType';
      yield serializers.serialize(
        object.libraryType,
        specifiedType: const FullType.nullable(ModelLibraryLibraryTypeEnum),
      );
    }
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.parentId != null) {
      yield r'parentId';
      yield serializers.serialize(
        object.parentId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.mediaCount != null) {
      yield r'mediaCount';
      yield serializers.serialize(
        object.mediaCount,
        specifiedType: const FullType(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ModelLibrary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ModelLibraryBuilder result,
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
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slug = valueDes;
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
        case r'isLibrary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isLibrary = valueDes;
          break;
        case r'libraryPath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.libraryPath = valueDes;
          break;
        case r'libraryType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ModelLibraryLibraryTypeEnum),
          ) as ModelLibraryLibraryTypeEnum?;
          if (valueDes == null) continue;
          result.libraryType = valueDes;
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
        case r'parentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.parentId = valueDes;
          break;
        case r'mediaCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.mediaCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ModelLibrary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ModelLibraryBuilder();
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

class ModelLibraryLibraryTypeEnum extends EnumClass {

  /// Type of media in the library
  @BuiltValueEnumConst(wireName: r'MOVIE')
  static const ModelLibraryLibraryTypeEnum MOVIE = _$modelLibraryLibraryTypeEnum_MOVIE;
  /// Type of media in the library
  @BuiltValueEnumConst(wireName: r'TV_SHOW')
  static const ModelLibraryLibraryTypeEnum TV_SHOW = _$modelLibraryLibraryTypeEnum_TV_SHOW;
  /// Type of media in the library
  @BuiltValueEnumConst(wireName: r'MUSIC')
  static const ModelLibraryLibraryTypeEnum MUSIC = _$modelLibraryLibraryTypeEnum_MUSIC;
  /// Type of media in the library
  @BuiltValueEnumConst(wireName: r'COMIC')
  static const ModelLibraryLibraryTypeEnum COMIC = _$modelLibraryLibraryTypeEnum_COMIC;

  static Serializer<ModelLibraryLibraryTypeEnum> get serializer => _$modelLibraryLibraryTypeEnumSerializer;

  const ModelLibraryLibraryTypeEnum._(String name): super(name);

  static BuiltSet<ModelLibraryLibraryTypeEnum> get values => _$modelLibraryLibraryTypeEnumValues;
  static ModelLibraryLibraryTypeEnum valueOf(String name) => _$modelLibraryLibraryTypeEnumValueOf(name);
}

