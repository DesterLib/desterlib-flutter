// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_library_put200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1LibraryPut200Response extends ApiV1LibraryPut200Response {
  @override
  final bool? success;
  @override
  final ApiV1LibraryPut200ResponseData? data;
  @override
  final String? message;

  factory _$ApiV1LibraryPut200Response([
    void Function(ApiV1LibraryPut200ResponseBuilder)? updates,
  ]) => (ApiV1LibraryPut200ResponseBuilder()..update(updates))._build();

  _$ApiV1LibraryPut200Response._({this.success, this.data, this.message})
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
        data == other.data &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1LibraryPut200Response')
          ..add('success', success)
          ..add('data', data)
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

  ApiV1LibraryPut200ResponseDataBuilder? _data;
  ApiV1LibraryPut200ResponseDataBuilder get data =>
      _$this._data ??= ApiV1LibraryPut200ResponseDataBuilder();
  set data(ApiV1LibraryPut200ResponseDataBuilder? data) => _$this._data = data;

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
      _data = $v.data?.toBuilder();
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
            data: _data?.build(),
            message: message,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        _data?.build();
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
