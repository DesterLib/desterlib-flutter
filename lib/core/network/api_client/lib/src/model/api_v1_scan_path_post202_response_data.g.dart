// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_scan_path_post202_response_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1ScanPathPost202ResponseData
    extends ApiV1ScanPathPost202ResponseData {
  @override
  final String? path;
  @override
  final String? mediaType;
  @override
  final bool? queued;
  @override
  final num? queuePosition;

  factory _$ApiV1ScanPathPost202ResponseData([
    void Function(ApiV1ScanPathPost202ResponseDataBuilder)? updates,
  ]) => (ApiV1ScanPathPost202ResponseDataBuilder()..update(updates))._build();

  _$ApiV1ScanPathPost202ResponseData._({
    this.path,
    this.mediaType,
    this.queued,
    this.queuePosition,
  }) : super._();
  @override
  ApiV1ScanPathPost202ResponseData rebuild(
    void Function(ApiV1ScanPathPost202ResponseDataBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1ScanPathPost202ResponseDataBuilder toBuilder() =>
      ApiV1ScanPathPost202ResponseDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1ScanPathPost202ResponseData &&
        path == other.path &&
        mediaType == other.mediaType &&
        queued == other.queued &&
        queuePosition == other.queuePosition;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, path.hashCode);
    _$hash = $jc(_$hash, mediaType.hashCode);
    _$hash = $jc(_$hash, queued.hashCode);
    _$hash = $jc(_$hash, queuePosition.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1ScanPathPost202ResponseData')
          ..add('path', path)
          ..add('mediaType', mediaType)
          ..add('queued', queued)
          ..add('queuePosition', queuePosition))
        .toString();
  }
}

class ApiV1ScanPathPost202ResponseDataBuilder
    implements
        Builder<
          ApiV1ScanPathPost202ResponseData,
          ApiV1ScanPathPost202ResponseDataBuilder
        > {
  _$ApiV1ScanPathPost202ResponseData? _$v;

  String? _path;
  String? get path => _$this._path;
  set path(String? path) => _$this._path = path;

  String? _mediaType;
  String? get mediaType => _$this._mediaType;
  set mediaType(String? mediaType) => _$this._mediaType = mediaType;

  bool? _queued;
  bool? get queued => _$this._queued;
  set queued(bool? queued) => _$this._queued = queued;

  num? _queuePosition;
  num? get queuePosition => _$this._queuePosition;
  set queuePosition(num? queuePosition) =>
      _$this._queuePosition = queuePosition;

  ApiV1ScanPathPost202ResponseDataBuilder() {
    ApiV1ScanPathPost202ResponseData._defaults(this);
  }

  ApiV1ScanPathPost202ResponseDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _path = $v.path;
      _mediaType = $v.mediaType;
      _queued = $v.queued;
      _queuePosition = $v.queuePosition;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1ScanPathPost202ResponseData other) {
    _$v = other as _$ApiV1ScanPathPost202ResponseData;
  }

  @override
  void update(void Function(ApiV1ScanPathPost202ResponseDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1ScanPathPost202ResponseData build() => _build();

  _$ApiV1ScanPathPost202ResponseData _build() {
    final _$result =
        _$v ??
        _$ApiV1ScanPathPost202ResponseData._(
          path: path,
          mediaType: mediaType,
          queued: queued,
          queuePosition: queuePosition,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
