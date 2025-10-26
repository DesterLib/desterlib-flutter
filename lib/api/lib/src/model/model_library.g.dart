// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_library.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ModelLibraryLibraryTypeEnum _$modelLibraryLibraryTypeEnum_MOVIE =
    const ModelLibraryLibraryTypeEnum._('MOVIE');
const ModelLibraryLibraryTypeEnum _$modelLibraryLibraryTypeEnum_TV_SHOW =
    const ModelLibraryLibraryTypeEnum._('TV_SHOW');
const ModelLibraryLibraryTypeEnum _$modelLibraryLibraryTypeEnum_MUSIC =
    const ModelLibraryLibraryTypeEnum._('MUSIC');
const ModelLibraryLibraryTypeEnum _$modelLibraryLibraryTypeEnum_COMIC =
    const ModelLibraryLibraryTypeEnum._('COMIC');

ModelLibraryLibraryTypeEnum _$modelLibraryLibraryTypeEnumValueOf(String name) {
  switch (name) {
    case 'MOVIE':
      return _$modelLibraryLibraryTypeEnum_MOVIE;
    case 'TV_SHOW':
      return _$modelLibraryLibraryTypeEnum_TV_SHOW;
    case 'MUSIC':
      return _$modelLibraryLibraryTypeEnum_MUSIC;
    case 'COMIC':
      return _$modelLibraryLibraryTypeEnum_COMIC;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ModelLibraryLibraryTypeEnum>
_$modelLibraryLibraryTypeEnumValues =
    BuiltSet<ModelLibraryLibraryTypeEnum>(const <ModelLibraryLibraryTypeEnum>[
      _$modelLibraryLibraryTypeEnum_MOVIE,
      _$modelLibraryLibraryTypeEnum_TV_SHOW,
      _$modelLibraryLibraryTypeEnum_MUSIC,
      _$modelLibraryLibraryTypeEnum_COMIC,
    ]);

Serializer<ModelLibraryLibraryTypeEnum>
_$modelLibraryLibraryTypeEnumSerializer =
    _$ModelLibraryLibraryTypeEnumSerializer();

class _$ModelLibraryLibraryTypeEnumSerializer
    implements PrimitiveSerializer<ModelLibraryLibraryTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MOVIE': 'MOVIE',
    'TV_SHOW': 'TV_SHOW',
    'MUSIC': 'MUSIC',
    'COMIC': 'COMIC',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MOVIE': 'MOVIE',
    'TV_SHOW': 'TV_SHOW',
    'MUSIC': 'MUSIC',
    'COMIC': 'COMIC',
  };

  @override
  final Iterable<Type> types = const <Type>[ModelLibraryLibraryTypeEnum];
  @override
  final String wireName = 'ModelLibraryLibraryTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    ModelLibraryLibraryTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ModelLibraryLibraryTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ModelLibraryLibraryTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$ModelLibrary extends ModelLibrary {
  @override
  final String id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final String? description;
  @override
  final String? posterUrl;
  @override
  final String? backdropUrl;
  @override
  final bool isLibrary;
  @override
  final String? libraryPath;
  @override
  final ModelLibraryLibraryTypeEnum? libraryType;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? parentId;
  @override
  final num? mediaCount;

  factory _$ModelLibrary([void Function(ModelLibraryBuilder)? updates]) =>
      (ModelLibraryBuilder()..update(updates))._build();

  _$ModelLibrary._({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.posterUrl,
    this.backdropUrl,
    required this.isLibrary,
    this.libraryPath,
    this.libraryType,
    required this.createdAt,
    required this.updatedAt,
    this.parentId,
    this.mediaCount,
  }) : super._();
  @override
  ModelLibrary rebuild(void Function(ModelLibraryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ModelLibraryBuilder toBuilder() => ModelLibraryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ModelLibrary &&
        id == other.id &&
        name == other.name &&
        slug == other.slug &&
        description == other.description &&
        posterUrl == other.posterUrl &&
        backdropUrl == other.backdropUrl &&
        isLibrary == other.isLibrary &&
        libraryPath == other.libraryPath &&
        libraryType == other.libraryType &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        parentId == other.parentId &&
        mediaCount == other.mediaCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, posterUrl.hashCode);
    _$hash = $jc(_$hash, backdropUrl.hashCode);
    _$hash = $jc(_$hash, isLibrary.hashCode);
    _$hash = $jc(_$hash, libraryPath.hashCode);
    _$hash = $jc(_$hash, libraryType.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jc(_$hash, mediaCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ModelLibrary')
          ..add('id', id)
          ..add('name', name)
          ..add('slug', slug)
          ..add('description', description)
          ..add('posterUrl', posterUrl)
          ..add('backdropUrl', backdropUrl)
          ..add('isLibrary', isLibrary)
          ..add('libraryPath', libraryPath)
          ..add('libraryType', libraryType)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('parentId', parentId)
          ..add('mediaCount', mediaCount))
        .toString();
  }
}

class ModelLibraryBuilder
    implements Builder<ModelLibrary, ModelLibraryBuilder> {
  _$ModelLibrary? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _posterUrl;
  String? get posterUrl => _$this._posterUrl;
  set posterUrl(String? posterUrl) => _$this._posterUrl = posterUrl;

  String? _backdropUrl;
  String? get backdropUrl => _$this._backdropUrl;
  set backdropUrl(String? backdropUrl) => _$this._backdropUrl = backdropUrl;

  bool? _isLibrary;
  bool? get isLibrary => _$this._isLibrary;
  set isLibrary(bool? isLibrary) => _$this._isLibrary = isLibrary;

  String? _libraryPath;
  String? get libraryPath => _$this._libraryPath;
  set libraryPath(String? libraryPath) => _$this._libraryPath = libraryPath;

  ModelLibraryLibraryTypeEnum? _libraryType;
  ModelLibraryLibraryTypeEnum? get libraryType => _$this._libraryType;
  set libraryType(ModelLibraryLibraryTypeEnum? libraryType) =>
      _$this._libraryType = libraryType;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _parentId;
  String? get parentId => _$this._parentId;
  set parentId(String? parentId) => _$this._parentId = parentId;

  num? _mediaCount;
  num? get mediaCount => _$this._mediaCount;
  set mediaCount(num? mediaCount) => _$this._mediaCount = mediaCount;

  ModelLibraryBuilder() {
    ModelLibrary._defaults(this);
  }

  ModelLibraryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _slug = $v.slug;
      _description = $v.description;
      _posterUrl = $v.posterUrl;
      _backdropUrl = $v.backdropUrl;
      _isLibrary = $v.isLibrary;
      _libraryPath = $v.libraryPath;
      _libraryType = $v.libraryType;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _parentId = $v.parentId;
      _mediaCount = $v.mediaCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ModelLibrary other) {
    _$v = other as _$ModelLibrary;
  }

  @override
  void update(void Function(ModelLibraryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ModelLibrary build() => _build();

  _$ModelLibrary _build() {
    final _$result =
        _$v ??
        _$ModelLibrary._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ModelLibrary', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'ModelLibrary',
            'name',
          ),
          slug: BuiltValueNullFieldError.checkNotNull(
            slug,
            r'ModelLibrary',
            'slug',
          ),
          description: description,
          posterUrl: posterUrl,
          backdropUrl: backdropUrl,
          isLibrary: BuiltValueNullFieldError.checkNotNull(
            isLibrary,
            r'ModelLibrary',
            'isLibrary',
          ),
          libraryPath: libraryPath,
          libraryType: libraryType,
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'ModelLibrary',
            'createdAt',
          ),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
            updatedAt,
            r'ModelLibrary',
            'updatedAt',
          ),
          parentId: parentId,
          mediaCount: mediaCount,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
