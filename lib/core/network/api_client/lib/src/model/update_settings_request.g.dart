// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_settings_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateSettingsRequest extends UpdateSettingsRequest {
  @override
  final String? tmdbApiKey;
  @override
  final num? port;
  @override
  final bool? enableRouteGuards;
  @override
  final bool? firstRun;
  @override
  final UpdateSettingsRequestScanSettings? scanSettings;

  factory _$UpdateSettingsRequest([
    void Function(UpdateSettingsRequestBuilder)? updates,
  ]) => (UpdateSettingsRequestBuilder()..update(updates))._build();

  _$UpdateSettingsRequest._({
    this.tmdbApiKey,
    this.port,
    this.enableRouteGuards,
    this.firstRun,
    this.scanSettings,
  }) : super._();
  @override
  UpdateSettingsRequest rebuild(
    void Function(UpdateSettingsRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateSettingsRequestBuilder toBuilder() =>
      UpdateSettingsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateSettingsRequest &&
        tmdbApiKey == other.tmdbApiKey &&
        port == other.port &&
        enableRouteGuards == other.enableRouteGuards &&
        firstRun == other.firstRun &&
        scanSettings == other.scanSettings;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tmdbApiKey.hashCode);
    _$hash = $jc(_$hash, port.hashCode);
    _$hash = $jc(_$hash, enableRouteGuards.hashCode);
    _$hash = $jc(_$hash, firstRun.hashCode);
    _$hash = $jc(_$hash, scanSettings.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateSettingsRequest')
          ..add('tmdbApiKey', tmdbApiKey)
          ..add('port', port)
          ..add('enableRouteGuards', enableRouteGuards)
          ..add('firstRun', firstRun)
          ..add('scanSettings', scanSettings))
        .toString();
  }
}

class UpdateSettingsRequestBuilder
    implements Builder<UpdateSettingsRequest, UpdateSettingsRequestBuilder> {
  _$UpdateSettingsRequest? _$v;

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

  UpdateSettingsRequestScanSettingsBuilder? _scanSettings;
  UpdateSettingsRequestScanSettingsBuilder get scanSettings =>
      _$this._scanSettings ??= UpdateSettingsRequestScanSettingsBuilder();
  set scanSettings(UpdateSettingsRequestScanSettingsBuilder? scanSettings) =>
      _$this._scanSettings = scanSettings;

  UpdateSettingsRequestBuilder() {
    UpdateSettingsRequest._defaults(this);
  }

  UpdateSettingsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tmdbApiKey = $v.tmdbApiKey;
      _port = $v.port;
      _enableRouteGuards = $v.enableRouteGuards;
      _firstRun = $v.firstRun;
      _scanSettings = $v.scanSettings?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateSettingsRequest other) {
    _$v = other as _$UpdateSettingsRequest;
  }

  @override
  void update(void Function(UpdateSettingsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateSettingsRequest build() => _build();

  _$UpdateSettingsRequest _build() {
    _$UpdateSettingsRequest _$result;
    try {
      _$result =
          _$v ??
          _$UpdateSettingsRequest._(
            tmdbApiKey: tmdbApiKey,
            port: port,
            enableRouteGuards: enableRouteGuards,
            firstRun: firstRun,
            scanSettings: _scanSettings?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scanSettings';
        _scanSettings?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'UpdateSettingsRequest',
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
