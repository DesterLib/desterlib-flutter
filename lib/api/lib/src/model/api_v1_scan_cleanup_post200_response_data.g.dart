// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_scan_cleanup_post200_response_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1ScanCleanupPost200ResponseData
    extends ApiV1ScanCleanupPost200ResponseData {
  @override
  final num? cleanedCount;
  @override
  final String? message;

  factory _$ApiV1ScanCleanupPost200ResponseData([
    void Function(ApiV1ScanCleanupPost200ResponseDataBuilder)? updates,
  ]) =>
      (ApiV1ScanCleanupPost200ResponseDataBuilder()..update(updates))._build();

  _$ApiV1ScanCleanupPost200ResponseData._({this.cleanedCount, this.message})
    : super._();
  @override
  ApiV1ScanCleanupPost200ResponseData rebuild(
    void Function(ApiV1ScanCleanupPost200ResponseDataBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1ScanCleanupPost200ResponseDataBuilder toBuilder() =>
      ApiV1ScanCleanupPost200ResponseDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1ScanCleanupPost200ResponseData &&
        cleanedCount == other.cleanedCount &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cleanedCount.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1ScanCleanupPost200ResponseData')
          ..add('cleanedCount', cleanedCount)
          ..add('message', message))
        .toString();
  }
}

class ApiV1ScanCleanupPost200ResponseDataBuilder
    implements
        Builder<
          ApiV1ScanCleanupPost200ResponseData,
          ApiV1ScanCleanupPost200ResponseDataBuilder
        > {
  _$ApiV1ScanCleanupPost200ResponseData? _$v;

  num? _cleanedCount;
  num? get cleanedCount => _$this._cleanedCount;
  set cleanedCount(num? cleanedCount) => _$this._cleanedCount = cleanedCount;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ApiV1ScanCleanupPost200ResponseDataBuilder() {
    ApiV1ScanCleanupPost200ResponseData._defaults(this);
  }

  ApiV1ScanCleanupPost200ResponseDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cleanedCount = $v.cleanedCount;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1ScanCleanupPost200ResponseData other) {
    _$v = other as _$ApiV1ScanCleanupPost200ResponseData;
  }

  @override
  void update(
    void Function(ApiV1ScanCleanupPost200ResponseDataBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1ScanCleanupPost200ResponseData build() => _build();

  _$ApiV1ScanCleanupPost200ResponseData _build() {
    final _$result =
        _$v ??
        _$ApiV1ScanCleanupPost200ResponseData._(
          cleanedCount: cleanedCount,
          message: message,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
