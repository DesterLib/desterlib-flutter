// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_scan_path_post_request_options_media_type_depth.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1ScanPathPostRequestOptionsMediaTypeDepth
    extends ApiV1ScanPathPostRequestOptionsMediaTypeDepth {
  @override
  final num? movie;
  @override
  final num? tv;

  factory _$ApiV1ScanPathPostRequestOptionsMediaTypeDepth([
    void Function(ApiV1ScanPathPostRequestOptionsMediaTypeDepthBuilder)?
    updates,
  ]) =>
      (ApiV1ScanPathPostRequestOptionsMediaTypeDepthBuilder()..update(updates))
          ._build();

  _$ApiV1ScanPathPostRequestOptionsMediaTypeDepth._({this.movie, this.tv})
    : super._();
  @override
  ApiV1ScanPathPostRequestOptionsMediaTypeDepth rebuild(
    void Function(ApiV1ScanPathPostRequestOptionsMediaTypeDepthBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1ScanPathPostRequestOptionsMediaTypeDepthBuilder toBuilder() =>
      ApiV1ScanPathPostRequestOptionsMediaTypeDepthBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1ScanPathPostRequestOptionsMediaTypeDepth &&
        movie == other.movie &&
        tv == other.tv;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, movie.hashCode);
    _$hash = $jc(_$hash, tv.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1ScanPathPostRequestOptionsMediaTypeDepth',
          )
          ..add('movie', movie)
          ..add('tv', tv))
        .toString();
  }
}

class ApiV1ScanPathPostRequestOptionsMediaTypeDepthBuilder
    implements
        Builder<
          ApiV1ScanPathPostRequestOptionsMediaTypeDepth,
          ApiV1ScanPathPostRequestOptionsMediaTypeDepthBuilder
        > {
  _$ApiV1ScanPathPostRequestOptionsMediaTypeDepth? _$v;

  num? _movie;
  num? get movie => _$this._movie;
  set movie(num? movie) => _$this._movie = movie;

  num? _tv;
  num? get tv => _$this._tv;
  set tv(num? tv) => _$this._tv = tv;

  ApiV1ScanPathPostRequestOptionsMediaTypeDepthBuilder() {
    ApiV1ScanPathPostRequestOptionsMediaTypeDepth._defaults(this);
  }

  ApiV1ScanPathPostRequestOptionsMediaTypeDepthBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _movie = $v.movie;
      _tv = $v.tv;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1ScanPathPostRequestOptionsMediaTypeDepth other) {
    _$v = other as _$ApiV1ScanPathPostRequestOptionsMediaTypeDepth;
  }

  @override
  void update(
    void Function(ApiV1ScanPathPostRequestOptionsMediaTypeDepthBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1ScanPathPostRequestOptionsMediaTypeDepth build() => _build();

  _$ApiV1ScanPathPostRequestOptionsMediaTypeDepth _build() {
    final _$result =
        _$v ??
        _$ApiV1ScanPathPostRequestOptionsMediaTypeDepth._(movie: movie, tv: tv);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
