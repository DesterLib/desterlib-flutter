// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_settings_reset_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1SettingsResetPost200Response
    extends ApiV1SettingsResetPost200Response {
  @override
  final bool? success;
  @override
  final String? message;
  @override
  final PublicSettings? data;

  factory _$ApiV1SettingsResetPost200Response([
    void Function(ApiV1SettingsResetPost200ResponseBuilder)? updates,
  ]) => (ApiV1SettingsResetPost200ResponseBuilder()..update(updates))._build();

  _$ApiV1SettingsResetPost200Response._({this.success, this.message, this.data})
    : super._();
  @override
  ApiV1SettingsResetPost200Response rebuild(
    void Function(ApiV1SettingsResetPost200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1SettingsResetPost200ResponseBuilder toBuilder() =>
      ApiV1SettingsResetPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1SettingsResetPost200Response &&
        success == other.success &&
        message == other.message &&
        data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1SettingsResetPost200Response')
          ..add('success', success)
          ..add('message', message)
          ..add('data', data))
        .toString();
  }
}

class ApiV1SettingsResetPost200ResponseBuilder
    implements
        Builder<
          ApiV1SettingsResetPost200Response,
          ApiV1SettingsResetPost200ResponseBuilder
        > {
  _$ApiV1SettingsResetPost200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  PublicSettingsBuilder? _data;
  PublicSettingsBuilder get data => _$this._data ??= PublicSettingsBuilder();
  set data(PublicSettingsBuilder? data) => _$this._data = data;

  ApiV1SettingsResetPost200ResponseBuilder() {
    ApiV1SettingsResetPost200Response._defaults(this);
  }

  ApiV1SettingsResetPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _message = $v.message;
      _data = $v.data?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1SettingsResetPost200Response other) {
    _$v = other as _$ApiV1SettingsResetPost200Response;
  }

  @override
  void update(
    void Function(ApiV1SettingsResetPost200ResponseBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1SettingsResetPost200Response build() => _build();

  _$ApiV1SettingsResetPost200Response _build() {
    _$ApiV1SettingsResetPost200Response _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1SettingsResetPost200Response._(
            success: success,
            message: message,
            data: _data?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        _data?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ApiV1SettingsResetPost200Response',
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
