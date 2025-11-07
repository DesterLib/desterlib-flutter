// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_search_get200_response_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1SearchGet200ResponseData extends ApiV1SearchGet200ResponseData {
  @override
  final BuiltList<ApiV1SearchGet200ResponseDataMoviesInner>? movies;
  @override
  final BuiltList<ApiV1SearchGet200ResponseDataTvShowsInner>? tvShows;

  factory _$ApiV1SearchGet200ResponseData([
    void Function(ApiV1SearchGet200ResponseDataBuilder)? updates,
  ]) => (ApiV1SearchGet200ResponseDataBuilder()..update(updates))._build();

  _$ApiV1SearchGet200ResponseData._({this.movies, this.tvShows}) : super._();
  @override
  ApiV1SearchGet200ResponseData rebuild(
    void Function(ApiV1SearchGet200ResponseDataBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1SearchGet200ResponseDataBuilder toBuilder() =>
      ApiV1SearchGet200ResponseDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1SearchGet200ResponseData &&
        movies == other.movies &&
        tvShows == other.tvShows;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, movies.hashCode);
    _$hash = $jc(_$hash, tvShows.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1SearchGet200ResponseData')
          ..add('movies', movies)
          ..add('tvShows', tvShows))
        .toString();
  }
}

class ApiV1SearchGet200ResponseDataBuilder
    implements
        Builder<
          ApiV1SearchGet200ResponseData,
          ApiV1SearchGet200ResponseDataBuilder
        > {
  _$ApiV1SearchGet200ResponseData? _$v;

  ListBuilder<ApiV1SearchGet200ResponseDataMoviesInner>? _movies;
  ListBuilder<ApiV1SearchGet200ResponseDataMoviesInner> get movies =>
      _$this._movies ??=
          ListBuilder<ApiV1SearchGet200ResponseDataMoviesInner>();
  set movies(ListBuilder<ApiV1SearchGet200ResponseDataMoviesInner>? movies) =>
      _$this._movies = movies;

  ListBuilder<ApiV1SearchGet200ResponseDataTvShowsInner>? _tvShows;
  ListBuilder<ApiV1SearchGet200ResponseDataTvShowsInner> get tvShows =>
      _$this._tvShows ??=
          ListBuilder<ApiV1SearchGet200ResponseDataTvShowsInner>();
  set tvShows(
    ListBuilder<ApiV1SearchGet200ResponseDataTvShowsInner>? tvShows,
  ) => _$this._tvShows = tvShows;

  ApiV1SearchGet200ResponseDataBuilder() {
    ApiV1SearchGet200ResponseData._defaults(this);
  }

  ApiV1SearchGet200ResponseDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _movies = $v.movies?.toBuilder();
      _tvShows = $v.tvShows?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1SearchGet200ResponseData other) {
    _$v = other as _$ApiV1SearchGet200ResponseData;
  }

  @override
  void update(void Function(ApiV1SearchGet200ResponseDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1SearchGet200ResponseData build() => _build();

  _$ApiV1SearchGet200ResponseData _build() {
    _$ApiV1SearchGet200ResponseData _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1SearchGet200ResponseData._(
            movies: _movies?.build(),
            tvShows: _tvShows?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'movies';
        _movies?.build();
        _$failedField = 'tvShows';
        _tvShows?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ApiV1SearchGet200ResponseData',
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
