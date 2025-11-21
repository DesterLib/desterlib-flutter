// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_settings.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicSettings extends PublicSettings {
  @override
  final String? tmdbApiKey;
  @override
  final num? port;
  @override
  final bool? enableRouteGuards;
  @override
  final bool? firstRun;

  factory _$PublicSettings([void Function(PublicSettingsBuilder)? updates]) =>
      (PublicSettingsBuilder()..update(updates))._build();

  _$PublicSettings._({
    this.tmdbApiKey,
    this.port,
    this.enableRouteGuards,
    this.firstRun,
  }) : super._();
  @override
  PublicSettings rebuild(void Function(PublicSettingsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicSettingsBuilder toBuilder() => PublicSettingsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicSettings &&
        tmdbApiKey == other.tmdbApiKey &&
        port == other.port &&
        enableRouteGuards == other.enableRouteGuards &&
        firstRun == other.firstRun;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tmdbApiKey.hashCode);
    _$hash = $jc(_$hash, port.hashCode);
    _$hash = $jc(_$hash, enableRouteGuards.hashCode);
    _$hash = $jc(_$hash, firstRun.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicSettings')
          ..add('tmdbApiKey', tmdbApiKey)
          ..add('port', port)
          ..add('enableRouteGuards', enableRouteGuards)
          ..add('firstRun', firstRun))
        .toString();
  }
}

class PublicSettingsBuilder
    implements Builder<PublicSettings, PublicSettingsBuilder> {
  _$PublicSettings? _$v;

  String? _tmdbApiKey;
  String? get tmdbApiKey => _$this._tmdbApiKey;
  set tmdbApiKey(String? tmdbApiKey) => _$this._tmdbApiKey = tmdbApiKey;

  num? _port;
  num? get port => _$this._port;
  set port(num? port) => _$this._port = port;

  bool? _enableRouteGuards;
  bool? get enableRouteGuards => _$this._enableRouteGuards;
  set enableRouteGuards(bool? enableRouteGuards) =>
      _$this._enableRouteGuards = enableRouteGuards;

  bool? _firstRun;
  bool? get firstRun => _$this._firstRun;
  set firstRun(bool? firstRun) => _$this._firstRun = firstRun;

  PublicSettingsBuilder() {
    PublicSettings._defaults(this);
  }

  PublicSettingsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tmdbApiKey = $v.tmdbApiKey;
      _port = $v.port;
      _enableRouteGuards = $v.enableRouteGuards;
      _firstRun = $v.firstRun;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicSettings other) {
    _$v = other as _$PublicSettings;
  }

  @override
  void update(void Function(PublicSettingsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicSettings build() => _build();

  _$PublicSettings _build() {
    final _$result =
        _$v ??
        _$PublicSettings._(
          tmdbApiKey: tmdbApiKey,
          port: port,
          enableRouteGuards: enableRouteGuards,
          firstRun: firstRun,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
