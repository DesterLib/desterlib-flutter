// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_tvshows_get200_response_data_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1TvshowsGet200ResponseDataInner
    extends ApiV1TvshowsGet200ResponseDataInner {
  @override
  final String? id;
  @override
  final String? creator;
  @override
  final String? network;
  @override
  final String? mediaId;
  @override
  final ApiV1TvshowsGet200ResponseDataInnerMedia? media;

  factory _$ApiV1TvshowsGet200ResponseDataInner([
    void Function(ApiV1TvshowsGet200ResponseDataInnerBuilder)? updates,
  ]) =>
      (ApiV1TvshowsGet200ResponseDataInnerBuilder()..update(updates))._build();

  _$ApiV1TvshowsGet200ResponseDataInner._({
    this.id,
    this.creator,
    this.network,
    this.mediaId,
    this.media,
  }) : super._();
  @override
  ApiV1TvshowsGet200ResponseDataInner rebuild(
    void Function(ApiV1TvshowsGet200ResponseDataInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1TvshowsGet200ResponseDataInnerBuilder toBuilder() =>
      ApiV1TvshowsGet200ResponseDataInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1TvshowsGet200ResponseDataInner &&
        id == other.id &&
        creator == other.creator &&
        network == other.network &&
        mediaId == other.mediaId &&
        media == other.media;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, creator.hashCode);
    _$hash = $jc(_$hash, network.hashCode);
    _$hash = $jc(_$hash, mediaId.hashCode);
    _$hash = $jc(_$hash, media.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1TvshowsGet200ResponseDataInner')
          ..add('id', id)
          ..add('creator', creator)
          ..add('network', network)
          ..add('mediaId', mediaId)
          ..add('media', media))
        .toString();
  }
}

class ApiV1TvshowsGet200ResponseDataInnerBuilder
    implements
        Builder<
          ApiV1TvshowsGet200ResponseDataInner,
          ApiV1TvshowsGet200ResponseDataInnerBuilder
        > {
  _$ApiV1TvshowsGet200ResponseDataInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _creator;
  String? get creator => _$this._creator;
  set creator(String? creator) => _$this._creator = creator;

  String? _network;
  String? get network => _$this._network;
  set network(String? network) => _$this._network = network;

  String? _mediaId;
  String? get mediaId => _$this._mediaId;
  set mediaId(String? mediaId) => _$this._mediaId = mediaId;

  ApiV1TvshowsGet200ResponseDataInnerMediaBuilder? _media;
  ApiV1TvshowsGet200ResponseDataInnerMediaBuilder get media =>
      _$this._media ??= ApiV1TvshowsGet200ResponseDataInnerMediaBuilder();
  set media(ApiV1TvshowsGet200ResponseDataInnerMediaBuilder? media) =>
      _$this._media = media;

  ApiV1TvshowsGet200ResponseDataInnerBuilder() {
    ApiV1TvshowsGet200ResponseDataInner._defaults(this);
  }

  ApiV1TvshowsGet200ResponseDataInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _creator = $v.creator;
      _network = $v.network;
      _mediaId = $v.mediaId;
      _media = $v.media?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1TvshowsGet200ResponseDataInner other) {
    _$v = other as _$ApiV1TvshowsGet200ResponseDataInner;
  }

  @override
  void update(
    void Function(ApiV1TvshowsGet200ResponseDataInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1TvshowsGet200ResponseDataInner build() => _build();

  _$ApiV1TvshowsGet200ResponseDataInner _build() {
    _$ApiV1TvshowsGet200ResponseDataInner _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1TvshowsGet200ResponseDataInner._(
            id: id,
            creator: creator,
            network: network,
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
          r'ApiV1TvshowsGet200ResponseDataInner',
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
