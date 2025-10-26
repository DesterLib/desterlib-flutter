// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_movies_id_get404_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1MoviesIdGet404Response extends ApiV1MoviesIdGet404Response {
  @override
  final String? error;
  @override
  final String? message;

  factory _$ApiV1MoviesIdGet404Response([
    void Function(ApiV1MoviesIdGet404ResponseBuilder)? updates,
  ]) => (ApiV1MoviesIdGet404ResponseBuilder()..update(updates))._build();

  _$ApiV1MoviesIdGet404Response._({this.error, this.message}) : super._();
  @override
  ApiV1MoviesIdGet404Response rebuild(
    void Function(ApiV1MoviesIdGet404ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1MoviesIdGet404ResponseBuilder toBuilder() =>
      ApiV1MoviesIdGet404ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1MoviesIdGet404Response &&
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
    return (newBuiltValueToStringHelper(r'ApiV1MoviesIdGet404Response')
          ..add('error', error)
          ..add('message', message))
        .toString();
  }
}

class ApiV1MoviesIdGet404ResponseBuilder
    implements
        Builder<
          ApiV1MoviesIdGet404Response,
          ApiV1MoviesIdGet404ResponseBuilder
        > {
  _$ApiV1MoviesIdGet404Response? _$v;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ApiV1MoviesIdGet404ResponseBuilder() {
    ApiV1MoviesIdGet404Response._defaults(this);
  }

  ApiV1MoviesIdGet404ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _error = $v.error;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1MoviesIdGet404Response other) {
    _$v = other as _$ApiV1MoviesIdGet404Response;
  }

  @override
  void update(void Function(ApiV1MoviesIdGet404ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1MoviesIdGet404Response build() => _build();

  _$ApiV1MoviesIdGet404Response _build() {
    final _$result =
        _$v ?? _$ApiV1MoviesIdGet404Response._(error: error, message: message);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
