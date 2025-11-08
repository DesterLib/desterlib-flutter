// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_tvshows_id_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1TvshowsIdGet200Response extends ApiV1TvshowsIdGet200Response {
  @override
  final bool? success;
  @override
  final ApiV1TvshowsIdGet200ResponseData? data;

  factory _$ApiV1TvshowsIdGet200Response([
    void Function(ApiV1TvshowsIdGet200ResponseBuilder)? updates,
  ]) => (ApiV1TvshowsIdGet200ResponseBuilder()..update(updates))._build();

  _$ApiV1TvshowsIdGet200Response._({this.success, this.data}) : super._();
  @override
  ApiV1TvshowsIdGet200Response rebuild(
    void Function(ApiV1TvshowsIdGet200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1TvshowsIdGet200ResponseBuilder toBuilder() =>
      ApiV1TvshowsIdGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1TvshowsIdGet200Response &&
        success == other.success &&
        data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1TvshowsIdGet200Response')
          ..add('success', success)
          ..add('data', data))
        .toString();
  }
}

class ApiV1TvshowsIdGet200ResponseBuilder
    implements
        Builder<
          ApiV1TvshowsIdGet200Response,
          ApiV1TvshowsIdGet200ResponseBuilder
        > {
  _$ApiV1TvshowsIdGet200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  ApiV1TvshowsIdGet200ResponseDataBuilder? _data;
  ApiV1TvshowsIdGet200ResponseDataBuilder get data =>
      _$this._data ??= ApiV1TvshowsIdGet200ResponseDataBuilder();
  set data(ApiV1TvshowsIdGet200ResponseDataBuilder? data) =>
      _$this._data = data;

  ApiV1TvshowsIdGet200ResponseBuilder() {
    ApiV1TvshowsIdGet200Response._defaults(this);
  }

  ApiV1TvshowsIdGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _data = $v.data?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1TvshowsIdGet200Response other) {
    _$v = other as _$ApiV1TvshowsIdGet200Response;
  }

  @override
  void update(void Function(ApiV1TvshowsIdGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1TvshowsIdGet200Response build() => _build();

  _$ApiV1TvshowsIdGet200Response _build() {
    _$ApiV1TvshowsIdGet200Response _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1TvshowsIdGet200Response._(
            success: success,
            data: _data?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        _data?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ApiV1TvshowsIdGet200Response',
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
