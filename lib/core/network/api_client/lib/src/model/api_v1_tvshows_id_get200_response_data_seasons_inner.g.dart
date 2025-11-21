// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_tvshows_id_get200_response_data_seasons_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1TvshowsIdGet200ResponseDataSeasonsInner
    extends ApiV1TvshowsIdGet200ResponseDataSeasonsInner {
  @override
  final String? id;
  @override
  final int? seasonNumber;
  @override
  final String? name;
  @override
  final String? overview;
  @override
  final DateTime? airDate;
  @override
  final String? posterUrl;
  @override
  final String? tvShowId;
  @override
  final BuiltList<ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner>?
  episodes;

  factory _$ApiV1TvshowsIdGet200ResponseDataSeasonsInner([
    void Function(ApiV1TvshowsIdGet200ResponseDataSeasonsInnerBuilder)? updates,
  ]) => (ApiV1TvshowsIdGet200ResponseDataSeasonsInnerBuilder()..update(updates))
      ._build();

  _$ApiV1TvshowsIdGet200ResponseDataSeasonsInner._({
    this.id,
    this.seasonNumber,
    this.name,
    this.overview,
    this.airDate,
    this.posterUrl,
    this.tvShowId,
    this.episodes,
  }) : super._();
  @override
  ApiV1TvshowsIdGet200ResponseDataSeasonsInner rebuild(
    void Function(ApiV1TvshowsIdGet200ResponseDataSeasonsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1TvshowsIdGet200ResponseDataSeasonsInnerBuilder toBuilder() =>
      ApiV1TvshowsIdGet200ResponseDataSeasonsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1TvshowsIdGet200ResponseDataSeasonsInner &&
        id == other.id &&
        seasonNumber == other.seasonNumber &&
        name == other.name &&
        overview == other.overview &&
        airDate == other.airDate &&
        posterUrl == other.posterUrl &&
        tvShowId == other.tvShowId &&
        episodes == other.episodes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, seasonNumber.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, overview.hashCode);
    _$hash = $jc(_$hash, airDate.hashCode);
    _$hash = $jc(_$hash, posterUrl.hashCode);
    _$hash = $jc(_$hash, tvShowId.hashCode);
    _$hash = $jc(_$hash, episodes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1TvshowsIdGet200ResponseDataSeasonsInner',
          )
          ..add('id', id)
          ..add('seasonNumber', seasonNumber)
          ..add('name', name)
          ..add('overview', overview)
          ..add('airDate', airDate)
          ..add('posterUrl', posterUrl)
          ..add('tvShowId', tvShowId)
          ..add('episodes', episodes))
        .toString();
  }
}

class ApiV1TvshowsIdGet200ResponseDataSeasonsInnerBuilder
    implements
        Builder<
          ApiV1TvshowsIdGet200ResponseDataSeasonsInner,
          ApiV1TvshowsIdGet200ResponseDataSeasonsInnerBuilder
        > {
  _$ApiV1TvshowsIdGet200ResponseDataSeasonsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _seasonNumber;
  int? get seasonNumber => _$this._seasonNumber;
  set seasonNumber(int? seasonNumber) => _$this._seasonNumber = seasonNumber;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _overview;
  String? get overview => _$this._overview;
  set overview(String? overview) => _$this._overview = overview;

  DateTime? _airDate;
  DateTime? get airDate => _$this._airDate;
  set airDate(DateTime? airDate) => _$this._airDate = airDate;

  String? _posterUrl;
  String? get posterUrl => _$this._posterUrl;
  set posterUrl(String? posterUrl) => _$this._posterUrl = posterUrl;

  String? _tvShowId;
  String? get tvShowId => _$this._tvShowId;
  set tvShowId(String? tvShowId) => _$this._tvShowId = tvShowId;

  ListBuilder<ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner>?
  _episodes;
  ListBuilder<ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner>
  get episodes => _$this._episodes ??=
      ListBuilder<ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner>();
  set episodes(
    ListBuilder<ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner>?
    episodes,
  ) => _$this._episodes = episodes;

  ApiV1TvshowsIdGet200ResponseDataSeasonsInnerBuilder() {
    ApiV1TvshowsIdGet200ResponseDataSeasonsInner._defaults(this);
  }

  ApiV1TvshowsIdGet200ResponseDataSeasonsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _seasonNumber = $v.seasonNumber;
      _name = $v.name;
      _overview = $v.overview;
      _airDate = $v.airDate;
      _posterUrl = $v.posterUrl;
      _tvShowId = $v.tvShowId;
      _episodes = $v.episodes?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1TvshowsIdGet200ResponseDataSeasonsInner other) {
    _$v = other as _$ApiV1TvshowsIdGet200ResponseDataSeasonsInner;
  }

  @override
  void update(
    void Function(ApiV1TvshowsIdGet200ResponseDataSeasonsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1TvshowsIdGet200ResponseDataSeasonsInner build() => _build();

  _$ApiV1TvshowsIdGet200ResponseDataSeasonsInner _build() {
    _$ApiV1TvshowsIdGet200ResponseDataSeasonsInner _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1TvshowsIdGet200ResponseDataSeasonsInner._(
            id: id,
            seasonNumber: seasonNumber,
            name: name,
            overview: overview,
            airDate: airDate,
            posterUrl: posterUrl,
            tvShowId: tvShowId,
            episodes: _episodes?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'episodes';
        _episodes?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ApiV1TvshowsIdGet200ResponseDataSeasonsInner',
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
