// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_scan_resume_scan_job_id_post202_response_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1ScanResumeScanJobIdPost202ResponseData
    extends ApiV1ScanResumeScanJobIdPost202ResponseData {
  @override
  final String? scanJobId;

  factory _$ApiV1ScanResumeScanJobIdPost202ResponseData([
    void Function(ApiV1ScanResumeScanJobIdPost202ResponseDataBuilder)? updates,
  ]) => (ApiV1ScanResumeScanJobIdPost202ResponseDataBuilder()..update(updates))
      ._build();

  _$ApiV1ScanResumeScanJobIdPost202ResponseData._({this.scanJobId}) : super._();
  @override
  ApiV1ScanResumeScanJobIdPost202ResponseData rebuild(
    void Function(ApiV1ScanResumeScanJobIdPost202ResponseDataBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1ScanResumeScanJobIdPost202ResponseDataBuilder toBuilder() =>
      ApiV1ScanResumeScanJobIdPost202ResponseDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1ScanResumeScanJobIdPost202ResponseData &&
        scanJobId == other.scanJobId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, scanJobId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'ApiV1ScanResumeScanJobIdPost202ResponseData',
    )..add('scanJobId', scanJobId)).toString();
  }
}

class ApiV1ScanResumeScanJobIdPost202ResponseDataBuilder
    implements
        Builder<
          ApiV1ScanResumeScanJobIdPost202ResponseData,
          ApiV1ScanResumeScanJobIdPost202ResponseDataBuilder
        > {
  _$ApiV1ScanResumeScanJobIdPost202ResponseData? _$v;

  String? _scanJobId;
  String? get scanJobId => _$this._scanJobId;
  set scanJobId(String? scanJobId) => _$this._scanJobId = scanJobId;

  ApiV1ScanResumeScanJobIdPost202ResponseDataBuilder() {
    ApiV1ScanResumeScanJobIdPost202ResponseData._defaults(this);
  }

  ApiV1ScanResumeScanJobIdPost202ResponseDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _scanJobId = $v.scanJobId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1ScanResumeScanJobIdPost202ResponseData other) {
    _$v = other as _$ApiV1ScanResumeScanJobIdPost202ResponseData;
  }

  @override
  void update(
    void Function(ApiV1ScanResumeScanJobIdPost202ResponseDataBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1ScanResumeScanJobIdPost202ResponseData build() => _build();

  _$ApiV1ScanResumeScanJobIdPost202ResponseData _build() {
    final _$result =
        _$v ??
        _$ApiV1ScanResumeScanJobIdPost202ResponseData._(scanJobId: scanJobId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
