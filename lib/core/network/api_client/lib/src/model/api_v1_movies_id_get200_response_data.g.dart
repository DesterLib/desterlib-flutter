// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_movies_id_get200_response_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1MoviesIdGet200ResponseData
    extends ApiV1MoviesIdGet200ResponseData {
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
  final String? streamUrl;
  @override
  final String? mediaId;
  @override
  final ApiV1MoviesIdGet200ResponseDataMedia? media;

  factory _$ApiV1MoviesIdGet200ResponseData([
    void Function(ApiV1MoviesIdGet200ResponseDataBuilder)? updates,
  ]) => (ApiV1MoviesIdGet200ResponseDataBuilder()..update(updates))._build();

  _$ApiV1MoviesIdGet200ResponseData._({
    this.id,
    this.duration,
    this.trailerUrl,
    this.filePath,
    this.fileSize,
    this.fileModifiedAt,
    this.streamUrl,
    this.mediaId,
    this.media,
  }) : super._();
  @override
  ApiV1MoviesIdGet200ResponseData rebuild(
    void Function(ApiV1MoviesIdGet200ResponseDataBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1MoviesIdGet200ResponseDataBuilder toBuilder() =>
      ApiV1MoviesIdGet200ResponseDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1MoviesIdGet200ResponseData &&
        id == other.id &&
        duration == other.duration &&
        trailerUrl == other.trailerUrl &&
        filePath == other.filePath &&
        fileSize == other.fileSize &&
        fileModifiedAt == other.fileModifiedAt &&
        streamUrl == other.streamUrl &&
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
    _$hash = $jc(_$hash, streamUrl.hashCode);
    _$hash = $jc(_$hash, mediaId.hashCode);
    _$hash = $jc(_$hash, media.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1MoviesIdGet200ResponseData')
          ..add('id', id)
          ..add('duration', duration)
          ..add('trailerUrl', trailerUrl)
          ..add('filePath', filePath)
          ..add('fileSize', fileSize)
          ..add('fileModifiedAt', fileModifiedAt)
          ..add('streamUrl', streamUrl)
          ..add('mediaId', mediaId)
          ..add('media', media))
        .toString();
  }
}

class ApiV1MoviesIdGet200ResponseDataBuilder
    implements
        Builder<
          ApiV1MoviesIdGet200ResponseData,
          ApiV1MoviesIdGet200ResponseDataBuilder
        > {
  _$ApiV1MoviesIdGet200ResponseData? _$v;

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

  String? _streamUrl;
  String? get streamUrl => _$this._streamUrl;
  set streamUrl(String? streamUrl) => _$this._streamUrl = streamUrl;

  String? _mediaId;
  String? get mediaId => _$this._mediaId;
  set mediaId(String? mediaId) => _$this._mediaId = mediaId;

  ApiV1MoviesIdGet200ResponseDataMediaBuilder? _media;
  ApiV1MoviesIdGet200ResponseDataMediaBuilder get media =>
      _$this._media ??= ApiV1MoviesIdGet200ResponseDataMediaBuilder();
  set media(ApiV1MoviesIdGet200ResponseDataMediaBuilder? media) =>
      _$this._media = media;

  ApiV1MoviesIdGet200ResponseDataBuilder() {
    ApiV1MoviesIdGet200ResponseData._defaults(this);
  }

  ApiV1MoviesIdGet200ResponseDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _duration = $v.duration;
      _trailerUrl = $v.trailerUrl;
      _filePath = $v.filePath;
      _fileSize = $v.fileSize;
      _fileModifiedAt = $v.fileModifiedAt;
      _streamUrl = $v.streamUrl;
      _mediaId = $v.mediaId;
      _media = $v.media?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1MoviesIdGet200ResponseData other) {
    _$v = other as _$ApiV1MoviesIdGet200ResponseData;
  }

  @override
  void update(void Function(ApiV1MoviesIdGet200ResponseDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1MoviesIdGet200ResponseData build() => _build();

  _$ApiV1MoviesIdGet200ResponseData _build() {
    _$ApiV1MoviesIdGet200ResponseData _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1MoviesIdGet200ResponseData._(
            id: id,
            duration: duration,
            trailerUrl: trailerUrl,
            filePath: filePath,
            fileSize: fileSize,
            fileModifiedAt: fileModifiedAt,
            streamUrl: streamUrl,
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
          r'ApiV1MoviesIdGet200ResponseData',
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
