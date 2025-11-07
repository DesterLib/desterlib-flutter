// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_search_get400_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1SearchGet400Response extends ApiV1SearchGet400Response {
  @override
  final bool? success;
  @override
  final String? error;
  @override
  final String? message;

  factory _$ApiV1SearchGet400Response([
    void Function(ApiV1SearchGet400ResponseBuilder)? updates,
  ]) => (ApiV1SearchGet400ResponseBuilder()..update(updates))._build();

  _$ApiV1SearchGet400Response._({this.success, this.error, this.message})
    : super._();
  @override
  ApiV1SearchGet400Response rebuild(
    void Function(ApiV1SearchGet400ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1SearchGet400ResponseBuilder toBuilder() =>
      ApiV1SearchGet400ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1SearchGet400Response &&
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
    return (newBuiltValueToStringHelper(r'ApiV1SearchGet400Response')
          ..add('success', success)
          ..add('error', error)
          ..add('message', message))
        .toString();
  }
}

class ApiV1SearchGet400ResponseBuilder
    implements
        Builder<ApiV1SearchGet400Response, ApiV1SearchGet400ResponseBuilder> {
  _$ApiV1SearchGet400Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ApiV1SearchGet400ResponseBuilder() {
    ApiV1SearchGet400Response._defaults(this);
  }

  ApiV1SearchGet400ResponseBuilder get _$this {
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
  void replace(ApiV1SearchGet400Response other) {
    _$v = other as _$ApiV1SearchGet400Response;
  }

  @override
  void update(void Function(ApiV1SearchGet400ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1SearchGet400Response build() => _build();

  _$ApiV1SearchGet400Response _build() {
    final _$result =
        _$v ??
        _$ApiV1SearchGet400Response._(
          success: success,
          error: error,
          message: message,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
