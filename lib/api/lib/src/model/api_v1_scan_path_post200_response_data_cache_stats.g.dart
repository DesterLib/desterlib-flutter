// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_scan_path_post200_response_data_cache_stats.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1ScanPathPost200ResponseDataCacheStats
    extends ApiV1ScanPathPost200ResponseDataCacheStats {
  @override
  final num? metadataFromCache;
  @override
  final num? metadataFromTMDB;
  @override
  final num? totalMetadataFetched;

  factory _$ApiV1ScanPathPost200ResponseDataCacheStats([
    void Function(ApiV1ScanPathPost200ResponseDataCacheStatsBuilder)? updates,
  ]) => (ApiV1ScanPathPost200ResponseDataCacheStatsBuilder()..update(updates))
      ._build();

  _$ApiV1ScanPathPost200ResponseDataCacheStats._({
    this.metadataFromCache,
    this.metadataFromTMDB,
    this.totalMetadataFetched,
  }) : super._();
  @override
  ApiV1ScanPathPost200ResponseDataCacheStats rebuild(
    void Function(ApiV1ScanPathPost200ResponseDataCacheStatsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1ScanPathPost200ResponseDataCacheStatsBuilder toBuilder() =>
      ApiV1ScanPathPost200ResponseDataCacheStatsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1ScanPathPost200ResponseDataCacheStats &&
        metadataFromCache == other.metadataFromCache &&
        metadataFromTMDB == other.metadataFromTMDB &&
        totalMetadataFetched == other.totalMetadataFetched;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, metadataFromCache.hashCode);
    _$hash = $jc(_$hash, metadataFromTMDB.hashCode);
    _$hash = $jc(_$hash, totalMetadataFetched.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1ScanPathPost200ResponseDataCacheStats',
          )
          ..add('metadataFromCache', metadataFromCache)
          ..add('metadataFromTMDB', metadataFromTMDB)
          ..add('totalMetadataFetched', totalMetadataFetched))
        .toString();
  }
}

class ApiV1ScanPathPost200ResponseDataCacheStatsBuilder
    implements
        Builder<
          ApiV1ScanPathPost200ResponseDataCacheStats,
          ApiV1ScanPathPost200ResponseDataCacheStatsBuilder
        > {
  _$ApiV1ScanPathPost200ResponseDataCacheStats? _$v;

  num? _metadataFromCache;
  num? get metadataFromCache => _$this._metadataFromCache;
  set metadataFromCache(num? metadataFromCache) =>
      _$this._metadataFromCache = metadataFromCache;

  num? _metadataFromTMDB;
  num? get metadataFromTMDB => _$this._metadataFromTMDB;
  set metadataFromTMDB(num? metadataFromTMDB) =>
      _$this._metadataFromTMDB = metadataFromTMDB;

  num? _totalMetadataFetched;
  num? get totalMetadataFetched => _$this._totalMetadataFetched;
  set totalMetadataFetched(num? totalMetadataFetched) =>
      _$this._totalMetadataFetched = totalMetadataFetched;

  ApiV1ScanPathPost200ResponseDataCacheStatsBuilder() {
    ApiV1ScanPathPost200ResponseDataCacheStats._defaults(this);
  }

  ApiV1ScanPathPost200ResponseDataCacheStatsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _metadataFromCache = $v.metadataFromCache;
      _metadataFromTMDB = $v.metadataFromTMDB;
      _totalMetadataFetched = $v.totalMetadataFetched;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1ScanPathPost200ResponseDataCacheStats other) {
    _$v = other as _$ApiV1ScanPathPost200ResponseDataCacheStats;
  }

  @override
  void update(
    void Function(ApiV1ScanPathPost200ResponseDataCacheStatsBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1ScanPathPost200ResponseDataCacheStats build() => _build();

  _$ApiV1ScanPathPost200ResponseDataCacheStats _build() {
    final _$result =
        _$v ??
        _$ApiV1ScanPathPost200ResponseDataCacheStats._(
          metadataFromCache: metadataFromCache,
          metadataFromTMDB: metadataFromTMDB,
          totalMetadataFetched: totalMetadataFetched,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
