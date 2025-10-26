// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_scan_path_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1ScanPathPost200Response extends ApiV1ScanPathPost200Response {
  @override
  final bool? success;
  @override
  final String? message;
  @override
  final String? libraryId;
  @override
  final String? libraryName;
  @override
  final num? totalFiles;
  @override
  final num? totalSaved;
  @override
  final ApiV1ScanPathPost200ResponseCacheStats? cacheStats;

  factory _$ApiV1ScanPathPost200Response([
    void Function(ApiV1ScanPathPost200ResponseBuilder)? updates,
  ]) => (ApiV1ScanPathPost200ResponseBuilder()..update(updates))._build();

  _$ApiV1ScanPathPost200Response._({
    this.success,
    this.message,
    this.libraryId,
    this.libraryName,
    this.totalFiles,
    this.totalSaved,
    this.cacheStats,
  }) : super._();
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
        message == other.message &&
        libraryId == other.libraryId &&
        libraryName == other.libraryName &&
        totalFiles == other.totalFiles &&
        totalSaved == other.totalSaved &&
        cacheStats == other.cacheStats;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
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
    return (newBuiltValueToStringHelper(r'ApiV1ScanPathPost200Response')
          ..add('success', success)
          ..add('message', message)
          ..add('libraryId', libraryId)
          ..add('libraryName', libraryName)
          ..add('totalFiles', totalFiles)
          ..add('totalSaved', totalSaved)
          ..add('cacheStats', cacheStats))
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

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

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

  ApiV1ScanPathPost200ResponseCacheStatsBuilder? _cacheStats;
  ApiV1ScanPathPost200ResponseCacheStatsBuilder get cacheStats =>
      _$this._cacheStats ??= ApiV1ScanPathPost200ResponseCacheStatsBuilder();
  set cacheStats(ApiV1ScanPathPost200ResponseCacheStatsBuilder? cacheStats) =>
      _$this._cacheStats = cacheStats;

  ApiV1ScanPathPost200ResponseBuilder() {
    ApiV1ScanPathPost200Response._defaults(this);
  }

  ApiV1ScanPathPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _message = $v.message;
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
            message: message,
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
