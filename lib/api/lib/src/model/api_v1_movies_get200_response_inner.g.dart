// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_movies_get200_response_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1MoviesGet200ResponseInner extends ApiV1MoviesGet200ResponseInner {
  @override
  final String? id;
  @override
  final num? duration;
  @override
  final String? trailerUrl;
  @override
  final String? filePath;
  @override
  final String? fileSize;
  @override
  final DateTime? fileModifiedAt;
  @override
  final String? mediaId;
  @override
  final ApiV1MoviesGet200ResponseInnerMedia? media;

  factory _$ApiV1MoviesGet200ResponseInner([
    void Function(ApiV1MoviesGet200ResponseInnerBuilder)? updates,
  ]) => (ApiV1MoviesGet200ResponseInnerBuilder()..update(updates))._build();

  _$ApiV1MoviesGet200ResponseInner._({
    this.id,
    this.duration,
    this.trailerUrl,
    this.filePath,
    this.fileSize,
    this.fileModifiedAt,
    this.mediaId,
    this.media,
  }) : super._();
  @override
  ApiV1MoviesGet200ResponseInner rebuild(
    void Function(ApiV1MoviesGet200ResponseInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1MoviesGet200ResponseInnerBuilder toBuilder() =>
      ApiV1MoviesGet200ResponseInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1MoviesGet200ResponseInner &&
        id == other.id &&
        duration == other.duration &&
        trailerUrl == other.trailerUrl &&
        filePath == other.filePath &&
        fileSize == other.fileSize &&
        fileModifiedAt == other.fileModifiedAt &&
        mediaId == other.mediaId &&
        media == other.media;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, trailerUrl.hashCode);
    _$hash = $jc(_$hash, filePath.hashCode);
    _$hash = $jc(_$hash, fileSize.hashCode);
    _$hash = $jc(_$hash, fileModifiedAt.hashCode);
    _$hash = $jc(_$hash, mediaId.hashCode);
    _$hash = $jc(_$hash, media.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1MoviesGet200ResponseInner')
          ..add('id', id)
          ..add('duration', duration)
          ..add('trailerUrl', trailerUrl)
          ..add('filePath', filePath)
          ..add('fileSize', fileSize)
          ..add('fileModifiedAt', fileModifiedAt)
          ..add('mediaId', mediaId)
          ..add('media', media))
        .toString();
  }
}

class ApiV1MoviesGet200ResponseInnerBuilder
    implements
        Builder<
          ApiV1MoviesGet200ResponseInner,
          ApiV1MoviesGet200ResponseInnerBuilder
        > {
  _$ApiV1MoviesGet200ResponseInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  num? _duration;
  num? get duration => _$this._duration;
  set duration(num? duration) => _$this._duration = duration;

  String? _trailerUrl;
  String? get trailerUrl => _$this._trailerUrl;
  set trailerUrl(String? trailerUrl) => _$this._trailerUrl = trailerUrl;

  String? _filePath;
  String? get filePath => _$this._filePath;
  set filePath(String? filePath) => _$this._filePath = filePath;

  String? _fileSize;
  String? get fileSize => _$this._fileSize;
  set fileSize(String? fileSize) => _$this._fileSize = fileSize;

  DateTime? _fileModifiedAt;
  DateTime? get fileModifiedAt => _$this._fileModifiedAt;
  set fileModifiedAt(DateTime? fileModifiedAt) =>
      _$this._fileModifiedAt = fileModifiedAt;

  String? _mediaId;
  String? get mediaId => _$this._mediaId;
  set mediaId(String? mediaId) => _$this._mediaId = mediaId;

  ApiV1MoviesGet200ResponseInnerMediaBuilder? _media;
  ApiV1MoviesGet200ResponseInnerMediaBuilder get media =>
      _$this._media ??= ApiV1MoviesGet200ResponseInnerMediaBuilder();
  set media(ApiV1MoviesGet200ResponseInnerMediaBuilder? media) =>
      _$this._media = media;

  ApiV1MoviesGet200ResponseInnerBuilder() {
    ApiV1MoviesGet200ResponseInner._defaults(this);
  }

  ApiV1MoviesGet200ResponseInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _duration = $v.duration;
      _trailerUrl = $v.trailerUrl;
      _filePath = $v.filePath;
      _fileSize = $v.fileSize;
      _fileModifiedAt = $v.fileModifiedAt;
      _mediaId = $v.mediaId;
      _media = $v.media?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1MoviesGet200ResponseInner other) {
    _$v = other as _$ApiV1MoviesGet200ResponseInner;
  }

  @override
  void update(void Function(ApiV1MoviesGet200ResponseInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1MoviesGet200ResponseInner build() => _build();

  _$ApiV1MoviesGet200ResponseInner _build() {
    _$ApiV1MoviesGet200ResponseInner _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1MoviesGet200ResponseInner._(
            id: id,
            duration: duration,
            trailerUrl: trailerUrl,
            filePath: filePath,
            fileSize: fileSize,
            fileModifiedAt: fileModifiedAt,
            mediaId: mediaId,
            media: _media?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'media';
        _media?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ApiV1MoviesGet200ResponseInner',
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
