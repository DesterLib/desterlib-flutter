// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_settings_scan_settings_media_type_depth.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicSettingsScanSettingsMediaTypeDepth
    extends PublicSettingsScanSettingsMediaTypeDepth {
  @override
  final num? movie;
  @override
  final num? tv;

  factory _$PublicSettingsScanSettingsMediaTypeDepth([
    void Function(PublicSettingsScanSettingsMediaTypeDepthBuilder)? updates,
  ]) => (PublicSettingsScanSettingsMediaTypeDepthBuilder()..update(updates))
      ._build();

  _$PublicSettingsScanSettingsMediaTypeDepth._({this.movie, this.tv})
    : super._();
  @override
  PublicSettingsScanSettingsMediaTypeDepth rebuild(
    void Function(PublicSettingsScanSettingsMediaTypeDepthBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PublicSettingsScanSettingsMediaTypeDepthBuilder toBuilder() =>
      PublicSettingsScanSettingsMediaTypeDepthBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicSettingsScanSettingsMediaTypeDepth &&
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
            r'PublicSettingsScanSettingsMediaTypeDepth',
          )
          ..add('movie', movie)
          ..add('tv', tv))
        .toString();
  }
}

class PublicSettingsScanSettingsMediaTypeDepthBuilder
    implements
        Builder<
          PublicSettingsScanSettingsMediaTypeDepth,
          PublicSettingsScanSettingsMediaTypeDepthBuilder
        > {
  _$PublicSettingsScanSettingsMediaTypeDepth? _$v;

  num? _movie;
  num? get movie => _$this._movie;
  set movie(num? movie) => _$this._movie = movie;

  num? _tv;
  num? get tv => _$this._tv;
  set tv(num? tv) => _$this._tv = tv;

  PublicSettingsScanSettingsMediaTypeDepthBuilder() {
    PublicSettingsScanSettingsMediaTypeDepth._defaults(this);
  }

  PublicSettingsScanSettingsMediaTypeDepthBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _movie = $v.movie;
      _tv = $v.tv;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicSettingsScanSettingsMediaTypeDepth other) {
    _$v = other as _$PublicSettingsScanSettingsMediaTypeDepth;
  }

  @override
  void update(
    void Function(PublicSettingsScanSettingsMediaTypeDepthBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  PublicSettingsScanSettingsMediaTypeDepth build() => _build();

  _$PublicSettingsScanSettingsMediaTypeDepth _build() {
    final _$result =
        _$v ??
        _$PublicSettingsScanSettingsMediaTypeDepth._(movie: movie, tv: tv);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
