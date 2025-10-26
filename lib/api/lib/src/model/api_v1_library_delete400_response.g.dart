// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_library_delete400_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1LibraryDelete400Response extends ApiV1LibraryDelete400Response {
  @override
  final String? error;
  @override
  final String? message;

  factory _$ApiV1LibraryDelete400Response([
    void Function(ApiV1LibraryDelete400ResponseBuilder)? updates,
  ]) => (ApiV1LibraryDelete400ResponseBuilder()..update(updates))._build();

  _$ApiV1LibraryDelete400Response._({this.error, this.message}) : super._();
  @override
  ApiV1LibraryDelete400Response rebuild(
    void Function(ApiV1LibraryDelete400ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1LibraryDelete400ResponseBuilder toBuilder() =>
      ApiV1LibraryDelete400ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1LibraryDelete400Response &&
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
    return (newBuiltValueToStringHelper(r'ApiV1LibraryDelete400Response')
          ..add('error', error)
          ..add('message', message))
        .toString();
  }
}

class ApiV1LibraryDelete400ResponseBuilder
    implements
        Builder<
          ApiV1LibraryDelete400Response,
          ApiV1LibraryDelete400ResponseBuilder
        > {
  _$ApiV1LibraryDelete400Response? _$v;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ApiV1LibraryDelete400ResponseBuilder() {
    ApiV1LibraryDelete400Response._defaults(this);
  }

  ApiV1LibraryDelete400ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _error = $v.error;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1LibraryDelete400Response other) {
    _$v = other as _$ApiV1LibraryDelete400Response;
  }

  @override
  void update(void Function(ApiV1LibraryDelete400ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1LibraryDelete400Response build() => _build();

  _$ApiV1LibraryDelete400Response _build() {
    final _$result =
        _$v ??
        _$ApiV1LibraryDelete400Response._(error: error, message: message);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
