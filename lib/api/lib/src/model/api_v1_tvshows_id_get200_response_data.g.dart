// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_tvshows_id_get200_response_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1TvshowsIdGet200ResponseData
    extends ApiV1TvshowsIdGet200ResponseData {
  @override
  final String? id;
  @override
  final String? creator;
  @override
  final String? network;
  @override
  final String? mediaId;
  @override
  final ApiV1TvshowsGet200ResponseDataInnerMedia? media;
  @override
  final BuiltList<ApiV1TvshowsIdGet200ResponseDataSeasonsInner>? seasons;

  factory _$ApiV1TvshowsIdGet200ResponseData([
    void Function(ApiV1TvshowsIdGet200ResponseDataBuilder)? updates,
  ]) => (ApiV1TvshowsIdGet200ResponseDataBuilder()..update(updates))._build();

  _$ApiV1TvshowsIdGet200ResponseData._({
    this.id,
    this.creator,
    this.network,
    this.mediaId,
    this.media,
    this.seasons,
  }) : super._();
  @override
  ApiV1TvshowsIdGet200ResponseData rebuild(
    void Function(ApiV1TvshowsIdGet200ResponseDataBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1TvshowsIdGet200ResponseDataBuilder toBuilder() =>
      ApiV1TvshowsIdGet200ResponseDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1TvshowsIdGet200ResponseData &&
        id == other.id &&
        creator == other.creator &&
        network == other.network &&
        mediaId == other.mediaId &&
        media == other.media &&
        seasons == other.seasons;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, creator.hashCode);
    _$hash = $jc(_$hash, network.hashCode);
    _$hash = $jc(_$hash, mediaId.hashCode);
    _$hash = $jc(_$hash, media.hashCode);
    _$hash = $jc(_$hash, seasons.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1TvshowsIdGet200ResponseData')
          ..add('id', id)
          ..add('creator', creator)
          ..add('network', network)
          ..add('mediaId', mediaId)
          ..add('media', media)
          ..add('seasons', seasons))
        .toString();
  }
}

class ApiV1TvshowsIdGet200ResponseDataBuilder
    implements
        Builder<
          ApiV1TvshowsIdGet200ResponseData,
          ApiV1TvshowsIdGet200ResponseDataBuilder
        > {
  _$ApiV1TvshowsIdGet200ResponseData? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _creator;
  String? get creator => _$this._creator;
  set creator(String? creator) => _$this._creator = creator;

  String? _network;
  String? get network => _$this._network;
  set network(String? network) => _$this._network = network;

  String? _mediaId;
  String? get mediaId => _$this._mediaId;
  set mediaId(String? mediaId) => _$this._mediaId = mediaId;

  ApiV1TvshowsGet200ResponseDataInnerMediaBuilder? _media;
  ApiV1TvshowsGet200ResponseDataInnerMediaBuilder get media =>
      _$this._media ??= ApiV1TvshowsGet200ResponseDataInnerMediaBuilder();
  set media(ApiV1TvshowsGet200ResponseDataInnerMediaBuilder? media) =>
      _$this._media = media;

  ListBuilder<ApiV1TvshowsIdGet200ResponseDataSeasonsInner>? _seasons;
  ListBuilder<ApiV1TvshowsIdGet200ResponseDataSeasonsInner> get seasons =>
      _$this._seasons ??=
          ListBuilder<ApiV1TvshowsIdGet200ResponseDataSeasonsInner>();
  set seasons(
    ListBuilder<ApiV1TvshowsIdGet200ResponseDataSeasonsInner>? seasons,
  ) => _$this._seasons = seasons;

  ApiV1TvshowsIdGet200ResponseDataBuilder() {
    ApiV1TvshowsIdGet200ResponseData._defaults(this);
  }

  ApiV1TvshowsIdGet200ResponseDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _creator = $v.creator;
      _network = $v.network;
      _mediaId = $v.mediaId;
      _media = $v.media?.toBuilder();
      _seasons = $v.seasons?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1TvshowsIdGet200ResponseData other) {
    _$v = other as _$ApiV1TvshowsIdGet200ResponseData;
  }

  @override
  void update(void Function(ApiV1TvshowsIdGet200ResponseDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1TvshowsIdGet200ResponseData build() => _build();

  _$ApiV1TvshowsIdGet200ResponseData _build() {
    _$ApiV1TvshowsIdGet200ResponseData _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1TvshowsIdGet200ResponseData._(
            id: id,
            creator: creator,
            network: network,
            mediaId: mediaId,
            media: _media?.build(),
            seasons: _seasons?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'media';
        _media?.build();
        _$failedField = 'seasons';
        _seasons?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ApiV1TvshowsIdGet200ResponseData',
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
