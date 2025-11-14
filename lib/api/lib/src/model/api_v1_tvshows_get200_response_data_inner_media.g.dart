// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_tvshows_get200_response_data_inner_media.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum
_$apiV1TvshowsGet200ResponseDataInnerMediaTypeEnum_MOVIE =
    const ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum._('MOVIE');
const ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum
_$apiV1TvshowsGet200ResponseDataInnerMediaTypeEnum_TV_SHOW =
    const ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum._('TV_SHOW');
const ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum
_$apiV1TvshowsGet200ResponseDataInnerMediaTypeEnum_MUSIC =
    const ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum._('MUSIC');
const ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum
_$apiV1TvshowsGet200ResponseDataInnerMediaTypeEnum_COMIC =
    const ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum._('COMIC');

ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum
_$apiV1TvshowsGet200ResponseDataInnerMediaTypeEnumValueOf(String name) {
  switch (name) {
    case 'MOVIE':
      return _$apiV1TvshowsGet200ResponseDataInnerMediaTypeEnum_MOVIE;
    case 'TV_SHOW':
      return _$apiV1TvshowsGet200ResponseDataInnerMediaTypeEnum_TV_SHOW;
    case 'MUSIC':
      return _$apiV1TvshowsGet200ResponseDataInnerMediaTypeEnum_MUSIC;
    case 'COMIC':
      return _$apiV1TvshowsGet200ResponseDataInnerMediaTypeEnum_COMIC;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum>
_$apiV1TvshowsGet200ResponseDataInnerMediaTypeEnumValues =
    BuiltSet<ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum>(
      const <ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum>[
        _$apiV1TvshowsGet200ResponseDataInnerMediaTypeEnum_MOVIE,
        _$apiV1TvshowsGet200ResponseDataInnerMediaTypeEnum_TV_SHOW,
        _$apiV1TvshowsGet200ResponseDataInnerMediaTypeEnum_MUSIC,
        _$apiV1TvshowsGet200ResponseDataInnerMediaTypeEnum_COMIC,
      ],
    );

Serializer<ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum>
_$apiV1TvshowsGet200ResponseDataInnerMediaTypeEnumSerializer =
    _$ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnumSerializer();

class _$ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnumSerializer
    implements
        PrimitiveSerializer<ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum> {
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
    ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum,
  ];
  @override
  final String wireName = 'ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$ApiV1TvshowsGet200ResponseDataInnerMedia
    extends ApiV1TvshowsGet200ResponseDataInnerMedia {
  @override
  final String? id;
  @override
  final String? title;
  @override
  final ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum? type;
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

  factory _$ApiV1TvshowsGet200ResponseDataInnerMedia([
    void Function(ApiV1TvshowsGet200ResponseDataInnerMediaBuilder)? updates,
  ]) => (ApiV1TvshowsGet200ResponseDataInnerMediaBuilder()..update(updates))
      ._build();

  _$ApiV1TvshowsGet200ResponseDataInnerMedia._({
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
  ApiV1TvshowsGet200ResponseDataInnerMedia rebuild(
    void Function(ApiV1TvshowsGet200ResponseDataInnerMediaBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1TvshowsGet200ResponseDataInnerMediaBuilder toBuilder() =>
      ApiV1TvshowsGet200ResponseDataInnerMediaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1TvshowsGet200ResponseDataInnerMedia &&
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
    return (newBuiltValueToStringHelper(
            r'ApiV1TvshowsGet200ResponseDataInnerMedia',
          )
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

class ApiV1TvshowsGet200ResponseDataInnerMediaBuilder
    implements
        Builder<
          ApiV1TvshowsGet200ResponseDataInnerMedia,
          ApiV1TvshowsGet200ResponseDataInnerMediaBuilder
        > {
  _$ApiV1TvshowsGet200ResponseDataInnerMedia? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum? _type;
  ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum? get type => _$this._type;
  set type(ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum? type) =>
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

  ApiV1TvshowsGet200ResponseDataInnerMediaBuilder() {
    ApiV1TvshowsGet200ResponseDataInnerMedia._defaults(this);
  }

  ApiV1TvshowsGet200ResponseDataInnerMediaBuilder get _$this {
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
  void replace(ApiV1TvshowsGet200ResponseDataInnerMedia other) {
    _$v = other as _$ApiV1TvshowsGet200ResponseDataInnerMedia;
  }

  @override
  void update(
    void Function(ApiV1TvshowsGet200ResponseDataInnerMediaBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1TvshowsGet200ResponseDataInnerMedia build() => _build();

  _$ApiV1TvshowsGet200ResponseDataInnerMedia _build() {
    _$ApiV1TvshowsGet200ResponseDataInnerMedia _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1TvshowsGet200ResponseDataInnerMedia._(
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
          r'ApiV1TvshowsGet200ResponseDataInnerMedia',
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
