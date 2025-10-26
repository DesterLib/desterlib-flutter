// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_library_delete200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1LibraryDelete200Response extends ApiV1LibraryDelete200Response {
  @override
  final bool? success;
  @override
  final String? libraryId;
  @override
  final String? libraryName;
  @override
  final num? mediaDeleted;
  @override
  final String? message;

  factory _$ApiV1LibraryDelete200Response([
    void Function(ApiV1LibraryDelete200ResponseBuilder)? updates,
  ]) => (ApiV1LibraryDelete200ResponseBuilder()..update(updates))._build();

  _$ApiV1LibraryDelete200Response._({
    this.success,
    this.libraryId,
    this.libraryName,
    this.mediaDeleted,
    this.message,
  }) : super._();
  @override
  ApiV1LibraryDelete200Response rebuild(
    void Function(ApiV1LibraryDelete200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1LibraryDelete200ResponseBuilder toBuilder() =>
      ApiV1LibraryDelete200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1LibraryDelete200Response &&
        success == other.success &&
        libraryId == other.libraryId &&
        libraryName == other.libraryName &&
        mediaDeleted == other.mediaDeleted &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, libraryId.hashCode);
    _$hash = $jc(_$hash, libraryName.hashCode);
    _$hash = $jc(_$hash, mediaDeleted.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1LibraryDelete200Response')
          ..add('success', success)
          ..add('libraryId', libraryId)
          ..add('libraryName', libraryName)
          ..add('mediaDeleted', mediaDeleted)
          ..add('message', message))
        .toString();
  }
}

class ApiV1LibraryDelete200ResponseBuilder
    implements
        Builder<
          ApiV1LibraryDelete200Response,
          ApiV1LibraryDelete200ResponseBuilder
        > {
  _$ApiV1LibraryDelete200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

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

  ApiV1LibraryDelete200ResponseBuilder() {
    ApiV1LibraryDelete200Response._defaults(this);
  }

  ApiV1LibraryDelete200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _libraryId = $v.libraryId;
      _libraryName = $v.libraryName;
      _mediaDeleted = $v.mediaDeleted;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1LibraryDelete200Response other) {
    _$v = other as _$ApiV1LibraryDelete200Response;
  }

  @override
  void update(void Function(ApiV1LibraryDelete200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1LibraryDelete200Response build() => _build();

  _$ApiV1LibraryDelete200Response _build() {
    final _$result =
        _$v ??
        _$ApiV1LibraryDelete200Response._(
          success: success,
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
