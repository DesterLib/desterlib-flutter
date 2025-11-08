// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_tvshows_id_get200_response_data_seasons_inner_episodes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner
    extends ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner {
  @override
  final String? id;
  @override
  final int? episodeNumber;
  @override
  final int? seasonNumber;
  @override
  final String? title;
  @override
  final String? overview;
  @override
  final DateTime? airDate;
  @override
  final int? runtime;
  @override
  final String? stillUrl;
  @override
  final String? filePath;
  @override
  final String? fileSize;
  @override
  final String? seasonId;
  @override
  final String? streamUrl;

  factory _$ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner([
    void Function(
      ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInnerBuilder,
    )?
    updates,
  ]) =>
      (ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInnerBuilder()
            ..update(updates))
          ._build();

  _$ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner._({
    this.id,
    this.episodeNumber,
    this.seasonNumber,
    this.title,
    this.overview,
    this.airDate,
    this.runtime,
    this.stillUrl,
    this.filePath,
    this.fileSize,
    this.seasonId,
    this.streamUrl,
  }) : super._();
  @override
  ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner rebuild(
    void Function(
      ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInnerBuilder
  toBuilder() =>
      ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner &&
        id == other.id &&
        episodeNumber == other.episodeNumber &&
        seasonNumber == other.seasonNumber &&
        title == other.title &&
        overview == other.overview &&
        airDate == other.airDate &&
        runtime == other.runtime &&
        stillUrl == other.stillUrl &&
        filePath == other.filePath &&
        fileSize == other.fileSize &&
        seasonId == other.seasonId &&
        streamUrl == other.streamUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, episodeNumber.hashCode);
    _$hash = $jc(_$hash, seasonNumber.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, overview.hashCode);
    _$hash = $jc(_$hash, airDate.hashCode);
    _$hash = $jc(_$hash, runtime.hashCode);
    _$hash = $jc(_$hash, stillUrl.hashCode);
    _$hash = $jc(_$hash, filePath.hashCode);
    _$hash = $jc(_$hash, fileSize.hashCode);
    _$hash = $jc(_$hash, seasonId.hashCode);
    _$hash = $jc(_$hash, streamUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner',
          )
          ..add('id', id)
          ..add('episodeNumber', episodeNumber)
          ..add('seasonNumber', seasonNumber)
          ..add('title', title)
          ..add('overview', overview)
          ..add('airDate', airDate)
          ..add('runtime', runtime)
          ..add('stillUrl', stillUrl)
          ..add('filePath', filePath)
          ..add('fileSize', fileSize)
          ..add('seasonId', seasonId)
          ..add('streamUrl', streamUrl))
        .toString();
  }
}

class ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInnerBuilder
    implements
        Builder<
          ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner,
          ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInnerBuilder
        > {
  _$ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _episodeNumber;
  int? get episodeNumber => _$this._episodeNumber;
  set episodeNumber(int? episodeNumber) =>
      _$this._episodeNumber = episodeNumber;

  int? _seasonNumber;
  int? get seasonNumber => _$this._seasonNumber;
  set seasonNumber(int? seasonNumber) => _$this._seasonNumber = seasonNumber;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _overview;
  String? get overview => _$this._overview;
  set overview(String? overview) => _$this._overview = overview;

  DateTime? _airDate;
  DateTime? get airDate => _$this._airDate;
  set airDate(DateTime? airDate) => _$this._airDate = airDate;

  int? _runtime;
  int? get runtime => _$this._runtime;
  set runtime(int? runtime) => _$this._runtime = runtime;

  String? _stillUrl;
  String? get stillUrl => _$this._stillUrl;
  set stillUrl(String? stillUrl) => _$this._stillUrl = stillUrl;

  String? _filePath;
  String? get filePath => _$this._filePath;
  set filePath(String? filePath) => _$this._filePath = filePath;

  String? _fileSize;
  String? get fileSize => _$this._fileSize;
  set fileSize(String? fileSize) => _$this._fileSize = fileSize;

  String? _seasonId;
  String? get seasonId => _$this._seasonId;
  set seasonId(String? seasonId) => _$this._seasonId = seasonId;

  String? _streamUrl;
  String? get streamUrl => _$this._streamUrl;
  set streamUrl(String? streamUrl) => _$this._streamUrl = streamUrl;

  ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInnerBuilder() {
    ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner._defaults(this);
  }

  ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _episodeNumber = $v.episodeNumber;
      _seasonNumber = $v.seasonNumber;
      _title = $v.title;
      _overview = $v.overview;
      _airDate = $v.airDate;
      _runtime = $v.runtime;
      _stillUrl = $v.stillUrl;
      _filePath = $v.filePath;
      _fileSize = $v.fileSize;
      _seasonId = $v.seasonId;
      _streamUrl = $v.streamUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner other,
  ) {
    _$v = other as _$ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner;
  }

  @override
  void update(
    void Function(
      ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner build() => _build();

  _$ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner _build() {
    final _$result =
        _$v ??
        _$ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner._(
          id: id,
          episodeNumber: episodeNumber,
          seasonNumber: seasonNumber,
          title: title,
          overview: overview,
          airDate: airDate,
          runtime: runtime,
          stillUrl: stillUrl,
          filePath: filePath,
          fileSize: fileSize,
          seasonId: seasonId,
          streamUrl: streamUrl,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
