// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_search_get200_response_data_movies_inner_media.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum
_$apiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum_MOVIE =
    const ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum._('MOVIE');
const ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum
_$apiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum_TV_SHOW =
    const ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum._('TV_SHOW');
const ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum
_$apiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum_MUSIC =
    const ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum._('MUSIC');
const ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum
_$apiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum_COMIC =
    const ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum._('COMIC');

ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum
_$apiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnumValueOf(String name) {
  switch (name) {
    case 'MOVIE':
      return _$apiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum_MOVIE;
    case 'TV_SHOW':
      return _$apiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum_TV_SHOW;
    case 'MUSIC':
      return _$apiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum_MUSIC;
    case 'COMIC':
      return _$apiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum_COMIC;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum>
_$apiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnumValues =
    BuiltSet<ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum>(
      const <ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum>[
        _$apiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum_MOVIE,
        _$apiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum_TV_SHOW,
        _$apiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum_MUSIC,
        _$apiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum_COMIC,
      ],
    );

Serializer<ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum>
_$apiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnumSerializer =
    _$ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnumSerializer();

class _$ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnumSerializer
    implements
        PrimitiveSerializer<
          ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum
        > {
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
    ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum,
  ];
  @override
  final String wireName =
      'ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$ApiV1SearchGet200ResponseDataMoviesInnerMedia
    extends ApiV1SearchGet200ResponseDataMoviesInnerMedia {
  @override
  final String? id;
  @override
  final String? title;
  @override
  final ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum? type;
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

  factory _$ApiV1SearchGet200ResponseDataMoviesInnerMedia([
    void Function(ApiV1SearchGet200ResponseDataMoviesInnerMediaBuilder)?
    updates,
  ]) =>
      (ApiV1SearchGet200ResponseDataMoviesInnerMediaBuilder()..update(updates))
          ._build();

  _$ApiV1SearchGet200ResponseDataMoviesInnerMedia._({
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
  ApiV1SearchGet200ResponseDataMoviesInnerMedia rebuild(
    void Function(ApiV1SearchGet200ResponseDataMoviesInnerMediaBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1SearchGet200ResponseDataMoviesInnerMediaBuilder toBuilder() =>
      ApiV1SearchGet200ResponseDataMoviesInnerMediaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1SearchGet200ResponseDataMoviesInnerMedia &&
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
    return (newBuiltValueToStringHelper(
            r'ApiV1SearchGet200ResponseDataMoviesInnerMedia',
          )
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

class ApiV1SearchGet200ResponseDataMoviesInnerMediaBuilder
    implements
        Builder<
          ApiV1SearchGet200ResponseDataMoviesInnerMedia,
          ApiV1SearchGet200ResponseDataMoviesInnerMediaBuilder
        > {
  _$ApiV1SearchGet200ResponseDataMoviesInnerMedia? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum? _type;
  ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum? get type =>
      _$this._type;
  set type(ApiV1SearchGet200ResponseDataMoviesInnerMediaTypeEnum? type) =>
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

  ApiV1SearchGet200ResponseDataMoviesInnerMediaBuilder() {
    ApiV1SearchGet200ResponseDataMoviesInnerMedia._defaults(this);
  }

  ApiV1SearchGet200ResponseDataMoviesInnerMediaBuilder get _$this {
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
  void replace(ApiV1SearchGet200ResponseDataMoviesInnerMedia other) {
    _$v = other as _$ApiV1SearchGet200ResponseDataMoviesInnerMedia;
  }

  @override
  void update(
    void Function(ApiV1SearchGet200ResponseDataMoviesInnerMediaBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1SearchGet200ResponseDataMoviesInnerMedia build() => _build();

  _$ApiV1SearchGet200ResponseDataMoviesInnerMedia _build() {
    final _$result =
        _$v ??
        _$ApiV1SearchGet200ResponseDataMoviesInnerMedia._(
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
