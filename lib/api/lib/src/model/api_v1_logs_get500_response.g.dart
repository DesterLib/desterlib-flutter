// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_logs_get500_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1LogsGet500Response extends ApiV1LogsGet500Response {
  @override
  final bool? success;
  @override
  final String? message;
  @override
  final String? error;

  factory _$ApiV1LogsGet500Response([
    void Function(ApiV1LogsGet500ResponseBuilder)? updates,
  ]) => (ApiV1LogsGet500ResponseBuilder()..update(updates))._build();

  _$ApiV1LogsGet500Response._({this.success, this.message, this.error})
    : super._();
  @override
  ApiV1LogsGet500Response rebuild(
    void Function(ApiV1LogsGet500ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1LogsGet500ResponseBuilder toBuilder() =>
      ApiV1LogsGet500ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1LogsGet500Response &&
        success == other.success &&
        message == other.message &&
        error == other.error;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1LogsGet500Response')
          ..add('success', success)
          ..add('message', message)
          ..add('error', error))
        .toString();
  }
}

class ApiV1LogsGet500ResponseBuilder
    implements
        Builder<ApiV1LogsGet500Response, ApiV1LogsGet500ResponseBuilder> {
  _$ApiV1LogsGet500Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  ApiV1LogsGet500ResponseBuilder() {
    ApiV1LogsGet500Response._defaults(this);
  }

  ApiV1LogsGet500ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _message = $v.message;
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1LogsGet500Response other) {
    _$v = other as _$ApiV1LogsGet500Response;
  }

  @override
  void update(void Function(ApiV1LogsGet500ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1LogsGet500Response build() => _build();

  _$ApiV1LogsGet500Response _build() {
    final _$result =
        _$v ??
        _$ApiV1LogsGet500Response._(
          success: success,
          message: message,
          error: error,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
