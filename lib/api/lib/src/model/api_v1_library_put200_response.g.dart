// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_library_put200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1LibraryPut200Response extends ApiV1LibraryPut200Response {
  @override
  final bool? success;
  @override
  final ModelLibrary? library_;
  @override
  final String? message;

  factory _$ApiV1LibraryPut200Response([
    void Function(ApiV1LibraryPut200ResponseBuilder)? updates,
  ]) => (ApiV1LibraryPut200ResponseBuilder()..update(updates))._build();

  _$ApiV1LibraryPut200Response._({this.success, this.library_, this.message})
    : super._();
  @override
  ApiV1LibraryPut200Response rebuild(
    void Function(ApiV1LibraryPut200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1LibraryPut200ResponseBuilder toBuilder() =>
      ApiV1LibraryPut200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1LibraryPut200Response &&
        success == other.success &&
        library_ == other.library_ &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, library_.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1LibraryPut200Response')
          ..add('success', success)
          ..add('library_', library_)
          ..add('message', message))
        .toString();
  }
}

class ApiV1LibraryPut200ResponseBuilder
    implements
        Builder<ApiV1LibraryPut200Response, ApiV1LibraryPut200ResponseBuilder> {
  _$ApiV1LibraryPut200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  ModelLibraryBuilder? _library_;
  ModelLibraryBuilder get library_ =>
      _$this._library_ ??= ModelLibraryBuilder();
  set library_(ModelLibraryBuilder? library_) => _$this._library_ = library_;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ApiV1LibraryPut200ResponseBuilder() {
    ApiV1LibraryPut200Response._defaults(this);
  }

  ApiV1LibraryPut200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _library_ = $v.library_?.toBuilder();
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1LibraryPut200Response other) {
    _$v = other as _$ApiV1LibraryPut200Response;
  }

  @override
  void update(void Function(ApiV1LibraryPut200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1LibraryPut200Response build() => _build();

  _$ApiV1LibraryPut200Response _build() {
    _$ApiV1LibraryPut200Response _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1LibraryPut200Response._(
            success: success,
            library_: _library_?.build(),
            message: message,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'library_';
        _library_?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ApiV1LibraryPut200Response',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
