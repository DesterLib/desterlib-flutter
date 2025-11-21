// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_library_delete200_response_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1LibraryDelete200ResponseData
    extends ApiV1LibraryDelete200ResponseData {
  @override
  final String? libraryId;
  @override
  final String? libraryName;
  @override
  final num? mediaDeleted;
  @override
  final String? message;

  factory _$ApiV1LibraryDelete200ResponseData([
    void Function(ApiV1LibraryDelete200ResponseDataBuilder)? updates,
  ]) => (ApiV1LibraryDelete200ResponseDataBuilder()..update(updates))._build();

  _$ApiV1LibraryDelete200ResponseData._({
    this.libraryId,
    this.libraryName,
    this.mediaDeleted,
    this.message,
  }) : super._();
  @override
  ApiV1LibraryDelete200ResponseData rebuild(
    void Function(ApiV1LibraryDelete200ResponseDataBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1LibraryDelete200ResponseDataBuilder toBuilder() =>
      ApiV1LibraryDelete200ResponseDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1LibraryDelete200ResponseData &&
        libraryId == other.libraryId &&
        libraryName == other.libraryName &&
        mediaDeleted == other.mediaDeleted &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, libraryId.hashCode);
    _$hash = $jc(_$hash, libraryName.hashCode);
    _$hash = $jc(_$hash, mediaDeleted.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1LibraryDelete200ResponseData')
          ..add('libraryId', libraryId)
          ..add('libraryName', libraryName)
          ..add('mediaDeleted', mediaDeleted)
          ..add('message', message))
        .toString();
  }
}

class ApiV1LibraryDelete200ResponseDataBuilder
    implements
        Builder<
          ApiV1LibraryDelete200ResponseData,
          ApiV1LibraryDelete200ResponseDataBuilder
        > {
  _$ApiV1LibraryDelete200ResponseData? _$v;

  String? _libraryId;
  String? get libraryId => _$this._libraryId;
  set libraryId(String? libraryId) => _$this._libraryId = libraryId;

  String? _libraryName;
  String? get libraryName => _$this._libraryName;
  set libraryName(String? libraryName) => _$this._libraryName = libraryName;

  num? _mediaDeleted;
  num? get mediaDeleted => _$this._mediaDeleted;
  set mediaDeleted(num? mediaDeleted) => _$this._mediaDeleted = mediaDeleted;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ApiV1LibraryDelete200ResponseDataBuilder() {
    ApiV1LibraryDelete200ResponseData._defaults(this);
  }

  ApiV1LibraryDelete200ResponseDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _libraryId = $v.libraryId;
      _libraryName = $v.libraryName;
      _mediaDeleted = $v.mediaDeleted;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1LibraryDelete200ResponseData other) {
    _$v = other as _$ApiV1LibraryDelete200ResponseData;
  }

  @override
  void update(
    void Function(ApiV1LibraryDelete200ResponseDataBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1LibraryDelete200ResponseData build() => _build();

  _$ApiV1LibraryDelete200ResponseData _build() {
    final _$result =
        _$v ??
        _$ApiV1LibraryDelete200ResponseData._(
          libraryId: libraryId,
          libraryName: libraryName,
          mediaDeleted: mediaDeleted,
          message: message,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
