// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_library_put200_response_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1LibraryPut200ResponseData extends ApiV1LibraryPut200ResponseData {
  @override
  final ModelLibrary? library_;
  @override
  final String? message;

  factory _$ApiV1LibraryPut200ResponseData([
    void Function(ApiV1LibraryPut200ResponseDataBuilder)? updates,
  ]) => (ApiV1LibraryPut200ResponseDataBuilder()..update(updates))._build();

  _$ApiV1LibraryPut200ResponseData._({this.library_, this.message}) : super._();
  @override
  ApiV1LibraryPut200ResponseData rebuild(
    void Function(ApiV1LibraryPut200ResponseDataBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1LibraryPut200ResponseDataBuilder toBuilder() =>
      ApiV1LibraryPut200ResponseDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1LibraryPut200ResponseData &&
        library_ == other.library_ &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, library_.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1LibraryPut200ResponseData')
          ..add('library_', library_)
          ..add('message', message))
        .toString();
  }
}

class ApiV1LibraryPut200ResponseDataBuilder
    implements
        Builder<
          ApiV1LibraryPut200ResponseData,
          ApiV1LibraryPut200ResponseDataBuilder
        > {
  _$ApiV1LibraryPut200ResponseData? _$v;

  ModelLibraryBuilder? _library_;
  ModelLibraryBuilder get library_ =>
      _$this._library_ ??= ModelLibraryBuilder();
  set library_(ModelLibraryBuilder? library_) => _$this._library_ = library_;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ApiV1LibraryPut200ResponseDataBuilder() {
    ApiV1LibraryPut200ResponseData._defaults(this);
  }

  ApiV1LibraryPut200ResponseDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _library_ = $v.library_?.toBuilder();
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1LibraryPut200ResponseData other) {
    _$v = other as _$ApiV1LibraryPut200ResponseData;
  }

  @override
  void update(void Function(ApiV1LibraryPut200ResponseDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1LibraryPut200ResponseData build() => _build();

  _$ApiV1LibraryPut200ResponseData _build() {
    _$ApiV1LibraryPut200ResponseData _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1LibraryPut200ResponseData._(
            library_: _library_?.build(),
            message: message,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'library_';
        _library_?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ApiV1LibraryPut200ResponseData',
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
