// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_movies_id_get200_response_data_media.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApiV1MoviesIdGet200ResponseDataMediaTypeEnum
_$apiV1MoviesIdGet200ResponseDataMediaTypeEnum_MOVIE =
    const ApiV1MoviesIdGet200ResponseDataMediaTypeEnum._('MOVIE');
const ApiV1MoviesIdGet200ResponseDataMediaTypeEnum
_$apiV1MoviesIdGet200ResponseDataMediaTypeEnum_TV_SHOW =
    const ApiV1MoviesIdGet200ResponseDataMediaTypeEnum._('TV_SHOW');
const ApiV1MoviesIdGet200ResponseDataMediaTypeEnum
_$apiV1MoviesIdGet200ResponseDataMediaTypeEnum_MUSIC =
    const ApiV1MoviesIdGet200ResponseDataMediaTypeEnum._('MUSIC');
const ApiV1MoviesIdGet200ResponseDataMediaTypeEnum
_$apiV1MoviesIdGet200ResponseDataMediaTypeEnum_COMIC =
    const ApiV1MoviesIdGet200ResponseDataMediaTypeEnum._('COMIC');

ApiV1MoviesIdGet200ResponseDataMediaTypeEnum
_$apiV1MoviesIdGet200ResponseDataMediaTypeEnumValueOf(String name) {
  switch (name) {
    case 'MOVIE':
      return _$apiV1MoviesIdGet200ResponseDataMediaTypeEnum_MOVIE;
    case 'TV_SHOW':
      return _$apiV1MoviesIdGet200ResponseDataMediaTypeEnum_TV_SHOW;
    case 'MUSIC':
      return _$apiV1MoviesIdGet200ResponseDataMediaTypeEnum_MUSIC;
    case 'COMIC':
      return _$apiV1MoviesIdGet200ResponseDataMediaTypeEnum_COMIC;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApiV1MoviesIdGet200ResponseDataMediaTypeEnum>
_$apiV1MoviesIdGet200ResponseDataMediaTypeEnumValues =
    BuiltSet<ApiV1MoviesIdGet200ResponseDataMediaTypeEnum>(
      const <ApiV1MoviesIdGet200ResponseDataMediaTypeEnum>[
        _$apiV1MoviesIdGet200ResponseDataMediaTypeEnum_MOVIE,
        _$apiV1MoviesIdGet200ResponseDataMediaTypeEnum_TV_SHOW,
        _$apiV1MoviesIdGet200ResponseDataMediaTypeEnum_MUSIC,
        _$apiV1MoviesIdGet200ResponseDataMediaTypeEnum_COMIC,
      ],
    );

Serializer<ApiV1MoviesIdGet200ResponseDataMediaTypeEnum>
_$apiV1MoviesIdGet200ResponseDataMediaTypeEnumSerializer =
    _$ApiV1MoviesIdGet200ResponseDataMediaTypeEnumSerializer();

class _$ApiV1MoviesIdGet200ResponseDataMediaTypeEnumSerializer
    implements
        PrimitiveSerializer<ApiV1MoviesIdGet200ResponseDataMediaTypeEnum> {
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
    ApiV1MoviesIdGet200ResponseDataMediaTypeEnum,
  ];
  @override
  final String wireName = 'ApiV1MoviesIdGet200ResponseDataMediaTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    ApiV1MoviesIdGet200ResponseDataMediaTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ApiV1MoviesIdGet200ResponseDataMediaTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ApiV1MoviesIdGet200ResponseDataMediaTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$ApiV1MoviesIdGet200ResponseDataMedia
    extends ApiV1MoviesIdGet200ResponseDataMedia {
  @override
  final String? id;
  @override
  final String? title;
  @override
  final ApiV1MoviesIdGet200ResponseDataMediaTypeEnum? type;
  @override
  final String? description;
  @override
  final String? posterUrl;
  @override
  final String? backdropUrl;
  @override
  final BuiltList<String>? meshGradientColors;
  @override
  final DateTime? releaseDate;
  @override
  final num? rating;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$ApiV1MoviesIdGet200ResponseDataMedia([
    void Function(ApiV1MoviesIdGet200ResponseDataMediaBuilder)? updates,
  ]) =>
      (ApiV1MoviesIdGet200ResponseDataMediaBuilder()..update(updates))._build();

  _$ApiV1MoviesIdGet200ResponseDataMedia._({
    this.id,
    this.title,
    this.type,
    this.description,
    this.posterUrl,
    this.backdropUrl,
    this.meshGradientColors,
    this.releaseDate,
    this.rating,
    this.createdAt,
    this.updatedAt,
  }) : super._();
  @override
  ApiV1MoviesIdGet200ResponseDataMedia rebuild(
    void Function(ApiV1MoviesIdGet200ResponseDataMediaBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1MoviesIdGet200ResponseDataMediaBuilder toBuilder() =>
      ApiV1MoviesIdGet200ResponseDataMediaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1MoviesIdGet200ResponseDataMedia &&
        id == other.id &&
        title == other.title &&
        type == other.type &&
        description == other.description &&
        posterUrl == other.posterUrl &&
        backdropUrl == other.backdropUrl &&
        meshGradientColors == other.meshGradientColors &&
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
    _$hash = $jc(_$hash, meshGradientColors.hashCode);
    _$hash = $jc(_$hash, releaseDate.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1MoviesIdGet200ResponseDataMedia')
          ..add('id', id)
          ..add('title', title)
          ..add('type', type)
          ..add('description', description)
          ..add('posterUrl', posterUrl)
          ..add('backdropUrl', backdropUrl)
          ..add('meshGradientColors', meshGradientColors)
          ..add('releaseDate', releaseDate)
          ..add('rating', rating)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ApiV1MoviesIdGet200ResponseDataMediaBuilder
    implements
        Builder<
          ApiV1MoviesIdGet200ResponseDataMedia,
          ApiV1MoviesIdGet200ResponseDataMediaBuilder
        > {
  _$ApiV1MoviesIdGet200ResponseDataMedia? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  ApiV1MoviesIdGet200ResponseDataMediaTypeEnum? _type;
  ApiV1MoviesIdGet200ResponseDataMediaTypeEnum? get type => _$this._type;
  set type(ApiV1MoviesIdGet200ResponseDataMediaTypeEnum? type) =>
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

  ListBuilder<String>? _meshGradientColors;
  ListBuilder<String> get meshGradientColors =>
      _$this._meshGradientColors ??= ListBuilder<String>();
  set meshGradientColors(ListBuilder<String>? meshGradientColors) =>
      _$this._meshGradientColors = meshGradientColors;

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

  ApiV1MoviesIdGet200ResponseDataMediaBuilder() {
    ApiV1MoviesIdGet200ResponseDataMedia._defaults(this);
  }

  ApiV1MoviesIdGet200ResponseDataMediaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _type = $v.type;
      _description = $v.description;
      _posterUrl = $v.posterUrl;
      _backdropUrl = $v.backdropUrl;
      _meshGradientColors = $v.meshGradientColors?.toBuilder();
      _releaseDate = $v.releaseDate;
      _rating = $v.rating;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1MoviesIdGet200ResponseDataMedia other) {
    _$v = other as _$ApiV1MoviesIdGet200ResponseDataMedia;
  }

  @override
  void update(
    void Function(ApiV1MoviesIdGet200ResponseDataMediaBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1MoviesIdGet200ResponseDataMedia build() => _build();

  _$ApiV1MoviesIdGet200ResponseDataMedia _build() {
    _$ApiV1MoviesIdGet200ResponseDataMedia _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1MoviesIdGet200ResponseDataMedia._(
            id: id,
            title: title,
            type: type,
            description: description,
            posterUrl: posterUrl,
            backdropUrl: backdropUrl,
            meshGradientColors: _meshGradientColors?.build(),
            releaseDate: releaseDate,
            rating: rating,
            createdAt: createdAt,
            updatedAt: updatedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meshGradientColors';
        _meshGradientColors?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ApiV1MoviesIdGet200ResponseDataMedia',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
