// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_search_get200_response_data_tv_shows_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1SearchGet200ResponseDataTvShowsInner
    extends ApiV1SearchGet200ResponseDataTvShowsInner {
  @override
  final String? id;
  @override
  final String? creator;
  @override
  final String? network;
  @override
  final String? mediaId;
  @override
  final ApiV1SearchGet200ResponseDataTvShowsInnerMedia? media;

  factory _$ApiV1SearchGet200ResponseDataTvShowsInner([
    void Function(ApiV1SearchGet200ResponseDataTvShowsInnerBuilder)? updates,
  ]) => (ApiV1SearchGet200ResponseDataTvShowsInnerBuilder()..update(updates))
      ._build();

  _$ApiV1SearchGet200ResponseDataTvShowsInner._({
    this.id,
    this.creator,
    this.network,
    this.mediaId,
    this.media,
  }) : super._();
  @override
  ApiV1SearchGet200ResponseDataTvShowsInner rebuild(
    void Function(ApiV1SearchGet200ResponseDataTvShowsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1SearchGet200ResponseDataTvShowsInnerBuilder toBuilder() =>
      ApiV1SearchGet200ResponseDataTvShowsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1SearchGet200ResponseDataTvShowsInner &&
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
    return (newBuiltValueToStringHelper(
            r'ApiV1SearchGet200ResponseDataTvShowsInner',
          )
          ..add('id', id)
          ..add('creator', creator)
          ..add('network', network)
          ..add('mediaId', mediaId)
          ..add('media', media))
        .toString();
  }
}

class ApiV1SearchGet200ResponseDataTvShowsInnerBuilder
    implements
        Builder<
          ApiV1SearchGet200ResponseDataTvShowsInner,
          ApiV1SearchGet200ResponseDataTvShowsInnerBuilder
        > {
  _$ApiV1SearchGet200ResponseDataTvShowsInner? _$v;

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

  ApiV1SearchGet200ResponseDataTvShowsInnerMediaBuilder? _media;
  ApiV1SearchGet200ResponseDataTvShowsInnerMediaBuilder get media =>
      _$this._media ??= ApiV1SearchGet200ResponseDataTvShowsInnerMediaBuilder();
  set media(ApiV1SearchGet200ResponseDataTvShowsInnerMediaBuilder? media) =>
      _$this._media = media;

  ApiV1SearchGet200ResponseDataTvShowsInnerBuilder() {
    ApiV1SearchGet200ResponseDataTvShowsInner._defaults(this);
  }

  ApiV1SearchGet200ResponseDataTvShowsInnerBuilder get _$this {
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
  void replace(ApiV1SearchGet200ResponseDataTvShowsInner other) {
    _$v = other as _$ApiV1SearchGet200ResponseDataTvShowsInner;
  }

  @override
  void update(
    void Function(ApiV1SearchGet200ResponseDataTvShowsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1SearchGet200ResponseDataTvShowsInner build() => _build();

  _$ApiV1SearchGet200ResponseDataTvShowsInner _build() {
    _$ApiV1SearchGet200ResponseDataTvShowsInner _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1SearchGet200ResponseDataTvShowsInner._(
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
          r'ApiV1SearchGet200ResponseDataTvShowsInner',
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
