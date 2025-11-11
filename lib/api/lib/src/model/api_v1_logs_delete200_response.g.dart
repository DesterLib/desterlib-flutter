// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_logs_delete200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1LogsDelete200Response extends ApiV1LogsDelete200Response {
  @override
  final bool? success;
  @override
  final String? message;

  factory _$ApiV1LogsDelete200Response([
    void Function(ApiV1LogsDelete200ResponseBuilder)? updates,
  ]) => (ApiV1LogsDelete200ResponseBuilder()..update(updates))._build();

  _$ApiV1LogsDelete200Response._({this.success, this.message}) : super._();
  @override
  ApiV1LogsDelete200Response rebuild(
    void Function(ApiV1LogsDelete200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1LogsDelete200ResponseBuilder toBuilder() =>
      ApiV1LogsDelete200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1LogsDelete200Response &&
        success == other.success &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1LogsDelete200Response')
          ..add('success', success)
          ..add('message', message))
        .toString();
  }
}

class ApiV1LogsDelete200ResponseBuilder
    implements
        Builder<ApiV1LogsDelete200Response, ApiV1LogsDelete200ResponseBuilder> {
  _$ApiV1LogsDelete200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ApiV1LogsDelete200ResponseBuilder() {
    ApiV1LogsDelete200Response._defaults(this);
  }

  ApiV1LogsDelete200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1LogsDelete200Response other) {
    _$v = other as _$ApiV1LogsDelete200Response;
  }

  @override
  void update(void Function(ApiV1LogsDelete200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1LogsDelete200Response build() => _build();

  _$ApiV1LogsDelete200Response _build() {
    final _$result =
        _$v ??
        _$ApiV1LogsDelete200Response._(success: success, message: message);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
