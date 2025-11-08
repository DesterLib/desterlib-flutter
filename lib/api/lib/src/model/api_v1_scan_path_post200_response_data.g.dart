// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_scan_path_post200_response_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1ScanPathPost200ResponseData
    extends ApiV1ScanPathPost200ResponseData {
  @override
  final String? libraryId;
  @override
  final String? libraryName;
  @override
  final num? totalFiles;
  @override
  final num? totalSaved;
  @override
  final ApiV1ScanPathPost200ResponseDataCacheStats? cacheStats;

  factory _$ApiV1ScanPathPost200ResponseData([
    void Function(ApiV1ScanPathPost200ResponseDataBuilder)? updates,
  ]) => (ApiV1ScanPathPost200ResponseDataBuilder()..update(updates))._build();

  _$ApiV1ScanPathPost200ResponseData._({
    this.libraryId,
    this.libraryName,
    this.totalFiles,
    this.totalSaved,
    this.cacheStats,
  }) : super._();
  @override
  ApiV1ScanPathPost200ResponseData rebuild(
    void Function(ApiV1ScanPathPost200ResponseDataBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1ScanPathPost200ResponseDataBuilder toBuilder() =>
      ApiV1ScanPathPost200ResponseDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1ScanPathPost200ResponseData &&
        libraryId == other.libraryId &&
        libraryName == other.libraryName &&
        totalFiles == other.totalFiles &&
        totalSaved == other.totalSaved &&
        cacheStats == other.cacheStats;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, libraryId.hashCode);
    _$hash = $jc(_$hash, libraryName.hashCode);
    _$hash = $jc(_$hash, totalFiles.hashCode);
    _$hash = $jc(_$hash, totalSaved.hashCode);
    _$hash = $jc(_$hash, cacheStats.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1ScanPathPost200ResponseData')
          ..add('libraryId', libraryId)
          ..add('libraryName', libraryName)
          ..add('totalFiles', totalFiles)
          ..add('totalSaved', totalSaved)
          ..add('cacheStats', cacheStats))
        .toString();
  }
}

class ApiV1ScanPathPost200ResponseDataBuilder
    implements
        Builder<
          ApiV1ScanPathPost200ResponseData,
          ApiV1ScanPathPost200ResponseDataBuilder
        > {
  _$ApiV1ScanPathPost200ResponseData? _$v;

  String? _libraryId;
  String? get libraryId => _$this._libraryId;
  set libraryId(String? libraryId) => _$this._libraryId = libraryId;

  String? _libraryName;
  String? get libraryName => _$this._libraryName;
  set libraryName(String? libraryName) => _$this._libraryName = libraryName;

  num? _totalFiles;
  num? get totalFiles => _$this._totalFiles;
  set totalFiles(num? totalFiles) => _$this._totalFiles = totalFiles;

  num? _totalSaved;
  num? get totalSaved => _$this._totalSaved;
  set totalSaved(num? totalSaved) => _$this._totalSaved = totalSaved;

  ApiV1ScanPathPost200ResponseDataCacheStatsBuilder? _cacheStats;
  ApiV1ScanPathPost200ResponseDataCacheStatsBuilder get cacheStats =>
      _$this._cacheStats ??=
          ApiV1ScanPathPost200ResponseDataCacheStatsBuilder();
  set cacheStats(
    ApiV1ScanPathPost200ResponseDataCacheStatsBuilder? cacheStats,
  ) => _$this._cacheStats = cacheStats;

  ApiV1ScanPathPost200ResponseDataBuilder() {
    ApiV1ScanPathPost200ResponseData._defaults(this);
  }

  ApiV1ScanPathPost200ResponseDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _libraryId = $v.libraryId;
      _libraryName = $v.libraryName;
      _totalFiles = $v.totalFiles;
      _totalSaved = $v.totalSaved;
      _cacheStats = $v.cacheStats?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1ScanPathPost200ResponseData other) {
    _$v = other as _$ApiV1ScanPathPost200ResponseData;
  }

  @override
  void update(void Function(ApiV1ScanPathPost200ResponseDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1ScanPathPost200ResponseData build() => _build();

  _$ApiV1ScanPathPost200ResponseData _build() {
    _$ApiV1ScanPathPost200ResponseData _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1ScanPathPost200ResponseData._(
            libraryId: libraryId,
            libraryName: libraryName,
            totalFiles: totalFiles,
            totalSaved: totalSaved,
            cacheStats: _cacheStats?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'cacheStats';
        _cacheStats?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ApiV1ScanPathPost200ResponseData',
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
