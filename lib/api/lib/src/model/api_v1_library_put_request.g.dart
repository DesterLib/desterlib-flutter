// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_library_put_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApiV1LibraryPutRequestLibraryTypeEnum
_$apiV1LibraryPutRequestLibraryTypeEnum_MOVIE =
    const ApiV1LibraryPutRequestLibraryTypeEnum._('MOVIE');
const ApiV1LibraryPutRequestLibraryTypeEnum
_$apiV1LibraryPutRequestLibraryTypeEnum_TV_SHOW =
    const ApiV1LibraryPutRequestLibraryTypeEnum._('TV_SHOW');
const ApiV1LibraryPutRequestLibraryTypeEnum
_$apiV1LibraryPutRequestLibraryTypeEnum_MUSIC =
    const ApiV1LibraryPutRequestLibraryTypeEnum._('MUSIC');
const ApiV1LibraryPutRequestLibraryTypeEnum
_$apiV1LibraryPutRequestLibraryTypeEnum_COMIC =
    const ApiV1LibraryPutRequestLibraryTypeEnum._('COMIC');

ApiV1LibraryPutRequestLibraryTypeEnum
_$apiV1LibraryPutRequestLibraryTypeEnumValueOf(String name) {
  switch (name) {
    case 'MOVIE':
      return _$apiV1LibraryPutRequestLibraryTypeEnum_MOVIE;
    case 'TV_SHOW':
      return _$apiV1LibraryPutRequestLibraryTypeEnum_TV_SHOW;
    case 'MUSIC':
      return _$apiV1LibraryPutRequestLibraryTypeEnum_MUSIC;
    case 'COMIC':
      return _$apiV1LibraryPutRequestLibraryTypeEnum_COMIC;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApiV1LibraryPutRequestLibraryTypeEnum>
_$apiV1LibraryPutRequestLibraryTypeEnumValues =
    BuiltSet<ApiV1LibraryPutRequestLibraryTypeEnum>(
      const <ApiV1LibraryPutRequestLibraryTypeEnum>[
        _$apiV1LibraryPutRequestLibraryTypeEnum_MOVIE,
        _$apiV1LibraryPutRequestLibraryTypeEnum_TV_SHOW,
        _$apiV1LibraryPutRequestLibraryTypeEnum_MUSIC,
        _$apiV1LibraryPutRequestLibraryTypeEnum_COMIC,
      ],
    );

Serializer<ApiV1LibraryPutRequestLibraryTypeEnum>
_$apiV1LibraryPutRequestLibraryTypeEnumSerializer =
    _$ApiV1LibraryPutRequestLibraryTypeEnumSerializer();

class _$ApiV1LibraryPutRequestLibraryTypeEnumSerializer
    implements PrimitiveSerializer<ApiV1LibraryPutRequestLibraryTypeEnum> {
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
    ApiV1LibraryPutRequestLibraryTypeEnum,
  ];
  @override
  final String wireName = 'ApiV1LibraryPutRequestLibraryTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    ApiV1LibraryPutRequestLibraryTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ApiV1LibraryPutRequestLibraryTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ApiV1LibraryPutRequestLibraryTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$ApiV1LibraryPutRequest extends ApiV1LibraryPutRequest {
  @override
  final String id;
  @override
  final String? name;
  @override
  final String? description;
  @override
  final String? posterUrl;
  @override
  final String? backdropUrl;
  @override
  final String? libraryPath;
  @override
  final ApiV1LibraryPutRequestLibraryTypeEnum? libraryType;

  factory _$ApiV1LibraryPutRequest([
    void Function(ApiV1LibraryPutRequestBuilder)? updates,
  ]) => (ApiV1LibraryPutRequestBuilder()..update(updates))._build();

  _$ApiV1LibraryPutRequest._({
    required this.id,
    this.name,
    this.description,
    this.posterUrl,
    this.backdropUrl,
    this.libraryPath,
    this.libraryType,
  }) : super._();
  @override
  ApiV1LibraryPutRequest rebuild(
    void Function(ApiV1LibraryPutRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1LibraryPutRequestBuilder toBuilder() =>
      ApiV1LibraryPutRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1LibraryPutRequest &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        posterUrl == other.posterUrl &&
        backdropUrl == other.backdropUrl &&
        libraryPath == other.libraryPath &&
        libraryType == other.libraryType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, posterUrl.hashCode);
    _$hash = $jc(_$hash, backdropUrl.hashCode);
    _$hash = $jc(_$hash, libraryPath.hashCode);
    _$hash = $jc(_$hash, libraryType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1LibraryPutRequest')
          ..add('id', id)
          ..add('name', name)
          ..add('description', description)
          ..add('posterUrl', posterUrl)
          ..add('backdropUrl', backdropUrl)
          ..add('libraryPath', libraryPath)
          ..add('libraryType', libraryType))
        .toString();
  }
}

class ApiV1LibraryPutRequestBuilder
    implements Builder<ApiV1LibraryPutRequest, ApiV1LibraryPutRequestBuilder> {
  _$ApiV1LibraryPutRequest? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _posterUrl;
  String? get posterUrl => _$this._posterUrl;
  set posterUrl(String? posterUrl) => _$this._posterUrl = posterUrl;

  String? _backdropUrl;
  String? get backdropUrl => _$this._backdropUrl;
  set backdropUrl(String? backdropUrl) => _$this._backdropUrl = backdropUrl;

  String? _libraryPath;
  String? get libraryPath => _$this._libraryPath;
  set libraryPath(String? libraryPath) => _$this._libraryPath = libraryPath;

  ApiV1LibraryPutRequestLibraryTypeEnum? _libraryType;
  ApiV1LibraryPutRequestLibraryTypeEnum? get libraryType => _$this._libraryType;
  set libraryType(ApiV1LibraryPutRequestLibraryTypeEnum? libraryType) =>
      _$this._libraryType = libraryType;

  ApiV1LibraryPutRequestBuilder() {
    ApiV1LibraryPutRequest._defaults(this);
  }

  ApiV1LibraryPutRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _description = $v.description;
      _posterUrl = $v.posterUrl;
      _backdropUrl = $v.backdropUrl;
      _libraryPath = $v.libraryPath;
      _libraryType = $v.libraryType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1LibraryPutRequest other) {
    _$v = other as _$ApiV1LibraryPutRequest;
  }

  @override
  void update(void Function(ApiV1LibraryPutRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1LibraryPutRequest build() => _build();

  _$ApiV1LibraryPutRequest _build() {
    final _$result =
        _$v ??
        _$ApiV1LibraryPutRequest._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'ApiV1LibraryPutRequest',
            'id',
          ),
          name: name,
          description: description,
          posterUrl: posterUrl,
          backdropUrl: backdropUrl,
          libraryPath: libraryPath,
          libraryType: libraryType,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
