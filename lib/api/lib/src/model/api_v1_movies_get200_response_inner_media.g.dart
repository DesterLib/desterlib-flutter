// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_movies_get200_response_inner_media.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApiV1MoviesGet200ResponseInnerMediaTypeEnum
_$apiV1MoviesGet200ResponseInnerMediaTypeEnum_MOVIE =
    const ApiV1MoviesGet200ResponseInnerMediaTypeEnum._('MOVIE');
const ApiV1MoviesGet200ResponseInnerMediaTypeEnum
_$apiV1MoviesGet200ResponseInnerMediaTypeEnum_TV_SHOW =
    const ApiV1MoviesGet200ResponseInnerMediaTypeEnum._('TV_SHOW');
const ApiV1MoviesGet200ResponseInnerMediaTypeEnum
_$apiV1MoviesGet200ResponseInnerMediaTypeEnum_MUSIC =
    const ApiV1MoviesGet200ResponseInnerMediaTypeEnum._('MUSIC');
const ApiV1MoviesGet200ResponseInnerMediaTypeEnum
_$apiV1MoviesGet200ResponseInnerMediaTypeEnum_COMIC =
    const ApiV1MoviesGet200ResponseInnerMediaTypeEnum._('COMIC');

ApiV1MoviesGet200ResponseInnerMediaTypeEnum
_$apiV1MoviesGet200ResponseInnerMediaTypeEnumValueOf(String name) {
  switch (name) {
    case 'MOVIE':
      return _$apiV1MoviesGet200ResponseInnerMediaTypeEnum_MOVIE;
    case 'TV_SHOW':
      return _$apiV1MoviesGet200ResponseInnerMediaTypeEnum_TV_SHOW;
    case 'MUSIC':
      return _$apiV1MoviesGet200ResponseInnerMediaTypeEnum_MUSIC;
    case 'COMIC':
      return _$apiV1MoviesGet200ResponseInnerMediaTypeEnum_COMIC;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApiV1MoviesGet200ResponseInnerMediaTypeEnum>
_$apiV1MoviesGet200ResponseInnerMediaTypeEnumValues =
    BuiltSet<ApiV1MoviesGet200ResponseInnerMediaTypeEnum>(
      const <ApiV1MoviesGet200ResponseInnerMediaTypeEnum>[
        _$apiV1MoviesGet200ResponseInnerMediaTypeEnum_MOVIE,
        _$apiV1MoviesGet200ResponseInnerMediaTypeEnum_TV_SHOW,
        _$apiV1MoviesGet200ResponseInnerMediaTypeEnum_MUSIC,
        _$apiV1MoviesGet200ResponseInnerMediaTypeEnum_COMIC,
      ],
    );

Serializer<ApiV1MoviesGet200ResponseInnerMediaTypeEnum>
_$apiV1MoviesGet200ResponseInnerMediaTypeEnumSerializer =
    _$ApiV1MoviesGet200ResponseInnerMediaTypeEnumSerializer();

class _$ApiV1MoviesGet200ResponseInnerMediaTypeEnumSerializer
    implements
        PrimitiveSerializer<ApiV1MoviesGet200ResponseInnerMediaTypeEnum> {
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
  final Iterable<Type> types = const <Type>[
    ApiV1MoviesGet200ResponseInnerMediaTypeEnum,
  ];
  @override
  final String wireName = 'ApiV1MoviesGet200ResponseInnerMediaTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    ApiV1MoviesGet200ResponseInnerMediaTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ApiV1MoviesGet200ResponseInnerMediaTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ApiV1MoviesGet200ResponseInnerMediaTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$ApiV1MoviesGet200ResponseInnerMedia
    extends ApiV1MoviesGet200ResponseInnerMedia {
  @override
  final String? id;
  @override
  final String? title;
  @override
  final ApiV1MoviesGet200ResponseInnerMediaTypeEnum? type;
  @override
  final String? description;
  @override
  final String? posterUrl;
  @override
  final String? backdropUrl;
  @override
  final DateTime? releaseDate;
  @override
  final num? rating;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$ApiV1MoviesGet200ResponseInnerMedia([
    void Function(ApiV1MoviesGet200ResponseInnerMediaBuilder)? updates,
  ]) =>
      (ApiV1MoviesGet200ResponseInnerMediaBuilder()..update(updates))._build();

  _$ApiV1MoviesGet200ResponseInnerMedia._({
    this.id,
    this.title,
    this.type,
    this.description,
    this.posterUrl,
    this.backdropUrl,
    this.releaseDate,
    this.rating,
    this.createdAt,
    this.updatedAt,
  }) : super._();
  @override
  ApiV1MoviesGet200ResponseInnerMedia rebuild(
    void Function(ApiV1MoviesGet200ResponseInnerMediaBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1MoviesGet200ResponseInnerMediaBuilder toBuilder() =>
      ApiV1MoviesGet200ResponseInnerMediaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1MoviesGet200ResponseInnerMedia &&
        id == other.id &&
        title == other.title &&
        type == other.type &&
        description == other.description &&
        posterUrl == other.posterUrl &&
        backdropUrl == other.backdropUrl &&
        releaseDate == other.releaseDate &&
        rating == other.rating &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, posterUrl.hashCode);
    _$hash = $jc(_$hash, backdropUrl.hashCode);
    _$hash = $jc(_$hash, releaseDate.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1MoviesGet200ResponseInnerMedia')
          ..add('id', id)
          ..add('title', title)
          ..add('type', type)
          ..add('description', description)
          ..add('posterUrl', posterUrl)
          ..add('backdropUrl', backdropUrl)
          ..add('releaseDate', releaseDate)
          ..add('rating', rating)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ApiV1MoviesGet200ResponseInnerMediaBuilder
    implements
        Builder<
          ApiV1MoviesGet200ResponseInnerMedia,
          ApiV1MoviesGet200ResponseInnerMediaBuilder
        > {
  _$ApiV1MoviesGet200ResponseInnerMedia? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  ApiV1MoviesGet200ResponseInnerMediaTypeEnum? _type;
  ApiV1MoviesGet200ResponseInnerMediaTypeEnum? get type => _$this._type;
  set type(ApiV1MoviesGet200ResponseInnerMediaTypeEnum? type) =>
      _$this._type = type;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _posterUrl;
  String? get posterUrl => _$this._posterUrl;
  set posterUrl(String? posterUrl) => _$this._posterUrl = posterUrl;

  String? _backdropUrl;
  String? get backdropUrl => _$this._backdropUrl;
  set backdropUrl(String? backdropUrl) => _$this._backdropUrl = backdropUrl;

  DateTime? _releaseDate;
  DateTime? get releaseDate => _$this._releaseDate;
  set releaseDate(DateTime? releaseDate) => _$this._releaseDate = releaseDate;

  num? _rating;
  num? get rating => _$this._rating;
  set rating(num? rating) => _$this._rating = rating;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ApiV1MoviesGet200ResponseInnerMediaBuilder() {
    ApiV1MoviesGet200ResponseInnerMedia._defaults(this);
  }

  ApiV1MoviesGet200ResponseInnerMediaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _type = $v.type;
      _description = $v.description;
      _posterUrl = $v.posterUrl;
      _backdropUrl = $v.backdropUrl;
      _releaseDate = $v.releaseDate;
      _rating = $v.rating;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1MoviesGet200ResponseInnerMedia other) {
    _$v = other as _$ApiV1MoviesGet200ResponseInnerMedia;
  }

  @override
  void update(
    void Function(ApiV1MoviesGet200ResponseInnerMediaBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1MoviesGet200ResponseInnerMedia build() => _build();

  _$ApiV1MoviesGet200ResponseInnerMedia _build() {
    final _$result =
        _$v ??
        _$ApiV1MoviesGet200ResponseInnerMedia._(
          id: id,
          title: title,
          type: type,
          description: description,
          posterUrl: posterUrl,
          backdropUrl: backdropUrl,
          releaseDate: releaseDate,
          rating: rating,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
