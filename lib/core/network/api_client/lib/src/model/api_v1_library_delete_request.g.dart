// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_library_delete_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1LibraryDeleteRequest extends ApiV1LibraryDeleteRequest {
  @override
  final String id;

  factory _$ApiV1LibraryDeleteRequest([
    void Function(ApiV1LibraryDeleteRequestBuilder)? updates,
  ]) => (ApiV1LibraryDeleteRequestBuilder()..update(updates))._build();

  _$ApiV1LibraryDeleteRequest._({required this.id}) : super._();
  @override
  ApiV1LibraryDeleteRequest rebuild(
    void Function(ApiV1LibraryDeleteRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1LibraryDeleteRequestBuilder toBuilder() =>
      ApiV1LibraryDeleteRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1LibraryDeleteRequest && id == other.id;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'ApiV1LibraryDeleteRequest',
    )..add('id', id)).toString();
  }
}

class ApiV1LibraryDeleteRequestBuilder
    implements
        Builder<ApiV1LibraryDeleteRequest, ApiV1LibraryDeleteRequestBuilder> {
  _$ApiV1LibraryDeleteRequest? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ApiV1LibraryDeleteRequestBuilder() {
    ApiV1LibraryDeleteRequest._defaults(this);
  }

  ApiV1LibraryDeleteRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1LibraryDeleteRequest other) {
    _$v = other as _$ApiV1LibraryDeleteRequest;
  }

  @override
  void update(void Function(ApiV1LibraryDeleteRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1LibraryDeleteRequest build() => _build();

  _$ApiV1LibraryDeleteRequest _build() {
    final _$result =
        _$v ??
        _$ApiV1LibraryDeleteRequest._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'ApiV1LibraryDeleteRequest',
            'id',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
