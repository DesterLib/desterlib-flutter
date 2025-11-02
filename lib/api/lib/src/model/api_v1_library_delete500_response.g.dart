// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_library_delete500_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1LibraryDelete500Response extends ApiV1LibraryDelete500Response {
  @override
  final bool? success;
  @override
  final String? error;
  @override
  final String? message;

  factory _$ApiV1LibraryDelete500Response([
    void Function(ApiV1LibraryDelete500ResponseBuilder)? updates,
  ]) => (ApiV1LibraryDelete500ResponseBuilder()..update(updates))._build();

  _$ApiV1LibraryDelete500Response._({this.success, this.error, this.message})
    : super._();
  @override
  ApiV1LibraryDelete500Response rebuild(
    void Function(ApiV1LibraryDelete500ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1LibraryDelete500ResponseBuilder toBuilder() =>
      ApiV1LibraryDelete500ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1LibraryDelete500Response &&
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
    return (newBuiltValueToStringHelper(r'ApiV1LibraryDelete500Response')
          ..add('success', success)
          ..add('error', error)
          ..add('message', message))
        .toString();
  }
}

class ApiV1LibraryDelete500ResponseBuilder
    implements
        Builder<
          ApiV1LibraryDelete500Response,
          ApiV1LibraryDelete500ResponseBuilder
        > {
  _$ApiV1LibraryDelete500Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ApiV1LibraryDelete500ResponseBuilder() {
    ApiV1LibraryDelete500Response._defaults(this);
  }

  ApiV1LibraryDelete500ResponseBuilder get _$this {
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
  void replace(ApiV1LibraryDelete500Response other) {
    _$v = other as _$ApiV1LibraryDelete500Response;
  }

  @override
  void update(void Function(ApiV1LibraryDelete500ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1LibraryDelete500Response build() => _build();

  _$ApiV1LibraryDelete500Response _build() {
    final _$result =
        _$v ??
        _$ApiV1LibraryDelete500Response._(
          success: success,
          error: error,
          message: message,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
