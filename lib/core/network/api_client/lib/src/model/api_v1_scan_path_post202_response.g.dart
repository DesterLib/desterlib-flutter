// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_scan_path_post202_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1ScanPathPost202Response extends ApiV1ScanPathPost202Response {
  @override
  final bool? success;
  @override
  final ApiV1ScanPathPost202ResponseData? data;
  @override
  final String? message;

  factory _$ApiV1ScanPathPost202Response([
    void Function(ApiV1ScanPathPost202ResponseBuilder)? updates,
  ]) => (ApiV1ScanPathPost202ResponseBuilder()..update(updates))._build();

  _$ApiV1ScanPathPost202Response._({this.success, this.data, this.message})
    : super._();
  @override
  ApiV1ScanPathPost202Response rebuild(
    void Function(ApiV1ScanPathPost202ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1ScanPathPost202ResponseBuilder toBuilder() =>
      ApiV1ScanPathPost202ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1ScanPathPost202Response &&
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
    return (newBuiltValueToStringHelper(r'ApiV1ScanPathPost202Response')
          ..add('success', success)
          ..add('data', data)
          ..add('message', message))
        .toString();
  }
}

class ApiV1ScanPathPost202ResponseBuilder
    implements
        Builder<
          ApiV1ScanPathPost202Response,
          ApiV1ScanPathPost202ResponseBuilder
        > {
  _$ApiV1ScanPathPost202Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  ApiV1ScanPathPost202ResponseDataBuilder? _data;
  ApiV1ScanPathPost202ResponseDataBuilder get data =>
      _$this._data ??= ApiV1ScanPathPost202ResponseDataBuilder();
  set data(ApiV1ScanPathPost202ResponseDataBuilder? data) =>
      _$this._data = data;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ApiV1ScanPathPost202ResponseBuilder() {
    ApiV1ScanPathPost202Response._defaults(this);
  }

  ApiV1ScanPathPost202ResponseBuilder get _$this {
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
  void replace(ApiV1ScanPathPost202Response other) {
    _$v = other as _$ApiV1ScanPathPost202Response;
  }

  @override
  void update(void Function(ApiV1ScanPathPost202ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1ScanPathPost202Response build() => _build();

  _$ApiV1ScanPathPost202Response _build() {
    _$ApiV1ScanPathPost202Response _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1ScanPathPost202Response._(
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
          r'ApiV1ScanPathPost202Response',
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
