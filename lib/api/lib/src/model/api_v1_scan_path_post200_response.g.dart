// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_scan_path_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1ScanPathPost200Response extends ApiV1ScanPathPost200Response {
  @override
  final bool? success;
  @override
  final ApiV1ScanPathPost200ResponseData? data;
  @override
  final String? message;

  factory _$ApiV1ScanPathPost200Response([
    void Function(ApiV1ScanPathPost200ResponseBuilder)? updates,
  ]) => (ApiV1ScanPathPost200ResponseBuilder()..update(updates))._build();

  _$ApiV1ScanPathPost200Response._({this.success, this.data, this.message})
    : super._();
  @override
  ApiV1ScanPathPost200Response rebuild(
    void Function(ApiV1ScanPathPost200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1ScanPathPost200ResponseBuilder toBuilder() =>
      ApiV1ScanPathPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1ScanPathPost200Response &&
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
    return (newBuiltValueToStringHelper(r'ApiV1ScanPathPost200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('message', message))
        .toString();
  }
}

class ApiV1ScanPathPost200ResponseBuilder
    implements
        Builder<
          ApiV1ScanPathPost200Response,
          ApiV1ScanPathPost200ResponseBuilder
        > {
  _$ApiV1ScanPathPost200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  ApiV1ScanPathPost200ResponseDataBuilder? _data;
  ApiV1ScanPathPost200ResponseDataBuilder get data =>
      _$this._data ??= ApiV1ScanPathPost200ResponseDataBuilder();
  set data(ApiV1ScanPathPost200ResponseDataBuilder? data) =>
      _$this._data = data;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ApiV1ScanPathPost200ResponseBuilder() {
    ApiV1ScanPathPost200Response._defaults(this);
  }

  ApiV1ScanPathPost200ResponseBuilder get _$this {
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
  void replace(ApiV1ScanPathPost200Response other) {
    _$v = other as _$ApiV1ScanPathPost200Response;
  }

  @override
  void update(void Function(ApiV1ScanPathPost200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1ScanPathPost200Response build() => _build();

  _$ApiV1ScanPathPost200Response _build() {
    _$ApiV1ScanPathPost200Response _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1ScanPathPost200Response._(
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
          r'ApiV1ScanPathPost200Response',
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
