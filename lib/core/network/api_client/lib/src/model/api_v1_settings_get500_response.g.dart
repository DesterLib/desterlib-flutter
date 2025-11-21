// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_settings_get500_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1SettingsGet500Response extends ApiV1SettingsGet500Response {
  @override
  final bool? success;
  @override
  final String? error;
  @override
  final String? message;

  factory _$ApiV1SettingsGet500Response([
    void Function(ApiV1SettingsGet500ResponseBuilder)? updates,
  ]) => (ApiV1SettingsGet500ResponseBuilder()..update(updates))._build();

  _$ApiV1SettingsGet500Response._({this.success, this.error, this.message})
    : super._();
  @override
  ApiV1SettingsGet500Response rebuild(
    void Function(ApiV1SettingsGet500ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1SettingsGet500ResponseBuilder toBuilder() =>
      ApiV1SettingsGet500ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1SettingsGet500Response &&
        success == other.success &&
        error == other.error &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1SettingsGet500Response')
          ..add('success', success)
          ..add('error', error)
          ..add('message', message))
        .toString();
  }
}

class ApiV1SettingsGet500ResponseBuilder
    implements
        Builder<
          ApiV1SettingsGet500Response,
          ApiV1SettingsGet500ResponseBuilder
        > {
  _$ApiV1SettingsGet500Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ApiV1SettingsGet500ResponseBuilder() {
    ApiV1SettingsGet500Response._defaults(this);
  }

  ApiV1SettingsGet500ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _error = $v.error;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1SettingsGet500Response other) {
    _$v = other as _$ApiV1SettingsGet500Response;
  }

  @override
  void update(void Function(ApiV1SettingsGet500ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1SettingsGet500Response build() => _build();

  _$ApiV1SettingsGet500Response _build() {
    final _$result =
        _$v ??
        _$ApiV1SettingsGet500Response._(
          success: success,
          error: error,
          message: message,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
