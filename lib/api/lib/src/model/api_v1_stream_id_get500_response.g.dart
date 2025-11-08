// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_stream_id_get500_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1StreamIdGet500Response extends ApiV1StreamIdGet500Response {
  @override
  final String? error;
  @override
  final String? message;

  factory _$ApiV1StreamIdGet500Response([
    void Function(ApiV1StreamIdGet500ResponseBuilder)? updates,
  ]) => (ApiV1StreamIdGet500ResponseBuilder()..update(updates))._build();

  _$ApiV1StreamIdGet500Response._({this.error, this.message}) : super._();
  @override
  ApiV1StreamIdGet500Response rebuild(
    void Function(ApiV1StreamIdGet500ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1StreamIdGet500ResponseBuilder toBuilder() =>
      ApiV1StreamIdGet500ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1StreamIdGet500Response &&
        error == other.error &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1StreamIdGet500Response')
          ..add('error', error)
          ..add('message', message))
        .toString();
  }
}

class ApiV1StreamIdGet500ResponseBuilder
    implements
        Builder<
          ApiV1StreamIdGet500Response,
          ApiV1StreamIdGet500ResponseBuilder
        > {
  _$ApiV1StreamIdGet500Response? _$v;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ApiV1StreamIdGet500ResponseBuilder() {
    ApiV1StreamIdGet500Response._defaults(this);
  }

  ApiV1StreamIdGet500ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _error = $v.error;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1StreamIdGet500Response other) {
    _$v = other as _$ApiV1StreamIdGet500Response;
  }

  @override
  void update(void Function(ApiV1StreamIdGet500ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1StreamIdGet500Response build() => _build();

  _$ApiV1StreamIdGet500Response _build() {
    final _$result =
        _$v ?? _$ApiV1StreamIdGet500Response._(error: error, message: message);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
