// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_search_get500_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1SearchGet500Response extends ApiV1SearchGet500Response {
  @override
  final bool? success;
  @override
  final String? error;
  @override
  final String? message;

  factory _$ApiV1SearchGet500Response([
    void Function(ApiV1SearchGet500ResponseBuilder)? updates,
  ]) => (ApiV1SearchGet500ResponseBuilder()..update(updates))._build();

  _$ApiV1SearchGet500Response._({this.success, this.error, this.message})
    : super._();
  @override
  ApiV1SearchGet500Response rebuild(
    void Function(ApiV1SearchGet500ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1SearchGet500ResponseBuilder toBuilder() =>
      ApiV1SearchGet500ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1SearchGet500Response &&
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
    return (newBuiltValueToStringHelper(r'ApiV1SearchGet500Response')
          ..add('success', success)
          ..add('error', error)
          ..add('message', message))
        .toString();
  }
}

class ApiV1SearchGet500ResponseBuilder
    implements
        Builder<ApiV1SearchGet500Response, ApiV1SearchGet500ResponseBuilder> {
  _$ApiV1SearchGet500Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ApiV1SearchGet500ResponseBuilder() {
    ApiV1SearchGet500Response._defaults(this);
  }

  ApiV1SearchGet500ResponseBuilder get _$this {
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
  void replace(ApiV1SearchGet500Response other) {
    _$v = other as _$ApiV1SearchGet500Response;
  }

  @override
  void update(void Function(ApiV1SearchGet500ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1SearchGet500Response build() => _build();

  _$ApiV1SearchGet500Response _build() {
    final _$result =
        _$v ??
        _$ApiV1SearchGet500Response._(
          success: success,
          error: error,
          message: message,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
