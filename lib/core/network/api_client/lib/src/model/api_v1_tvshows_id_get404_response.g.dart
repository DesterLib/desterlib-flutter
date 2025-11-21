// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_tvshows_id_get404_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1TvshowsIdGet404Response extends ApiV1TvshowsIdGet404Response {
  @override
  final bool? success;
  @override
  final String? error;
  @override
  final String? message;

  factory _$ApiV1TvshowsIdGet404Response([
    void Function(ApiV1TvshowsIdGet404ResponseBuilder)? updates,
  ]) => (ApiV1TvshowsIdGet404ResponseBuilder()..update(updates))._build();

  _$ApiV1TvshowsIdGet404Response._({this.success, this.error, this.message})
    : super._();
  @override
  ApiV1TvshowsIdGet404Response rebuild(
    void Function(ApiV1TvshowsIdGet404ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1TvshowsIdGet404ResponseBuilder toBuilder() =>
      ApiV1TvshowsIdGet404ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1TvshowsIdGet404Response &&
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
    return (newBuiltValueToStringHelper(r'ApiV1TvshowsIdGet404Response')
          ..add('success', success)
          ..add('error', error)
          ..add('message', message))
        .toString();
  }
}

class ApiV1TvshowsIdGet404ResponseBuilder
    implements
        Builder<
          ApiV1TvshowsIdGet404Response,
          ApiV1TvshowsIdGet404ResponseBuilder
        > {
  _$ApiV1TvshowsIdGet404Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ApiV1TvshowsIdGet404ResponseBuilder() {
    ApiV1TvshowsIdGet404Response._defaults(this);
  }

  ApiV1TvshowsIdGet404ResponseBuilder get _$this {
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
  void replace(ApiV1TvshowsIdGet404Response other) {
    _$v = other as _$ApiV1TvshowsIdGet404Response;
  }

  @override
  void update(void Function(ApiV1TvshowsIdGet404ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1TvshowsIdGet404Response build() => _build();

  _$ApiV1TvshowsIdGet404Response _build() {
    final _$result =
        _$v ??
        _$ApiV1TvshowsIdGet404Response._(
          success: success,
          error: error,
          message: message,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
