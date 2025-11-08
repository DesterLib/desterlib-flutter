// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_settings_first_run_complete_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1SettingsFirstRunCompletePost200Response
    extends ApiV1SettingsFirstRunCompletePost200Response {
  @override
  final bool? success;
  @override
  final String? message;
  @override
  final JsonObject? data;

  factory _$ApiV1SettingsFirstRunCompletePost200Response([
    void Function(ApiV1SettingsFirstRunCompletePost200ResponseBuilder)? updates,
  ]) => (ApiV1SettingsFirstRunCompletePost200ResponseBuilder()..update(updates))
      ._build();

  _$ApiV1SettingsFirstRunCompletePost200Response._({
    this.success,
    this.message,
    this.data,
  }) : super._();
  @override
  ApiV1SettingsFirstRunCompletePost200Response rebuild(
    void Function(ApiV1SettingsFirstRunCompletePost200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1SettingsFirstRunCompletePost200ResponseBuilder toBuilder() =>
      ApiV1SettingsFirstRunCompletePost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1SettingsFirstRunCompletePost200Response &&
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
    return (newBuiltValueToStringHelper(
            r'ApiV1SettingsFirstRunCompletePost200Response',
          )
          ..add('success', success)
          ..add('message', message)
          ..add('data', data))
        .toString();
  }
}

class ApiV1SettingsFirstRunCompletePost200ResponseBuilder
    implements
        Builder<
          ApiV1SettingsFirstRunCompletePost200Response,
          ApiV1SettingsFirstRunCompletePost200ResponseBuilder
        > {
  _$ApiV1SettingsFirstRunCompletePost200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  JsonObject? _data;
  JsonObject? get data => _$this._data;
  set data(JsonObject? data) => _$this._data = data;

  ApiV1SettingsFirstRunCompletePost200ResponseBuilder() {
    ApiV1SettingsFirstRunCompletePost200Response._defaults(this);
  }

  ApiV1SettingsFirstRunCompletePost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _message = $v.message;
      _data = $v.data;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1SettingsFirstRunCompletePost200Response other) {
    _$v = other as _$ApiV1SettingsFirstRunCompletePost200Response;
  }

  @override
  void update(
    void Function(ApiV1SettingsFirstRunCompletePost200ResponseBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1SettingsFirstRunCompletePost200Response build() => _build();

  _$ApiV1SettingsFirstRunCompletePost200Response _build() {
    final _$result =
        _$v ??
        _$ApiV1SettingsFirstRunCompletePost200Response._(
          success: success,
          message: message,
          data: data,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
