// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_scan_resume_scan_job_id_post202_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1ScanResumeScanJobIdPost202Response
    extends ApiV1ScanResumeScanJobIdPost202Response {
  @override
  final bool? success;
  @override
  final String? message;
  @override
  final ApiV1ScanResumeScanJobIdPost202ResponseData? data;

  factory _$ApiV1ScanResumeScanJobIdPost202Response([
    void Function(ApiV1ScanResumeScanJobIdPost202ResponseBuilder)? updates,
  ]) => (ApiV1ScanResumeScanJobIdPost202ResponseBuilder()..update(updates))
      ._build();

  _$ApiV1ScanResumeScanJobIdPost202Response._({
    this.success,
    this.message,
    this.data,
  }) : super._();
  @override
  ApiV1ScanResumeScanJobIdPost202Response rebuild(
    void Function(ApiV1ScanResumeScanJobIdPost202ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1ScanResumeScanJobIdPost202ResponseBuilder toBuilder() =>
      ApiV1ScanResumeScanJobIdPost202ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1ScanResumeScanJobIdPost202Response &&
        success == other.success &&
        message == other.message &&
        data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1ScanResumeScanJobIdPost202Response',
          )
          ..add('success', success)
          ..add('message', message)
          ..add('data', data))
        .toString();
  }
}

class ApiV1ScanResumeScanJobIdPost202ResponseBuilder
    implements
        Builder<
          ApiV1ScanResumeScanJobIdPost202Response,
          ApiV1ScanResumeScanJobIdPost202ResponseBuilder
        > {
  _$ApiV1ScanResumeScanJobIdPost202Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ApiV1ScanResumeScanJobIdPost202ResponseDataBuilder? _data;
  ApiV1ScanResumeScanJobIdPost202ResponseDataBuilder get data =>
      _$this._data ??= ApiV1ScanResumeScanJobIdPost202ResponseDataBuilder();
  set data(ApiV1ScanResumeScanJobIdPost202ResponseDataBuilder? data) =>
      _$this._data = data;

  ApiV1ScanResumeScanJobIdPost202ResponseBuilder() {
    ApiV1ScanResumeScanJobIdPost202Response._defaults(this);
  }

  ApiV1ScanResumeScanJobIdPost202ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _message = $v.message;
      _data = $v.data?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1ScanResumeScanJobIdPost202Response other) {
    _$v = other as _$ApiV1ScanResumeScanJobIdPost202Response;
  }

  @override
  void update(
    void Function(ApiV1ScanResumeScanJobIdPost202ResponseBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1ScanResumeScanJobIdPost202Response build() => _build();

  _$ApiV1ScanResumeScanJobIdPost202Response _build() {
    _$ApiV1ScanResumeScanJobIdPost202Response _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1ScanResumeScanJobIdPost202Response._(
            success: success,
            message: message,
            data: _data?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        _data?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ApiV1ScanResumeScanJobIdPost202Response',
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
