// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_movies_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1MoviesGet200Response extends ApiV1MoviesGet200Response {
  @override
  final bool? success;
  @override
  final BuiltList<String>? data;
  @override
  final JsonObject? properties;

  factory _$ApiV1MoviesGet200Response([
    void Function(ApiV1MoviesGet200ResponseBuilder)? updates,
  ]) => (ApiV1MoviesGet200ResponseBuilder()..update(updates))._build();

  _$ApiV1MoviesGet200Response._({this.success, this.data, this.properties})
    : super._();
  @override
  ApiV1MoviesGet200Response rebuild(
    void Function(ApiV1MoviesGet200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1MoviesGet200ResponseBuilder toBuilder() =>
      ApiV1MoviesGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1MoviesGet200Response &&
        success == other.success &&
        data == other.data &&
        properties == other.properties;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, properties.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1MoviesGet200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('properties', properties))
        .toString();
  }
}

class ApiV1MoviesGet200ResponseBuilder
    implements
        Builder<ApiV1MoviesGet200Response, ApiV1MoviesGet200ResponseBuilder> {
  _$ApiV1MoviesGet200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  ListBuilder<String>? _data;
  ListBuilder<String> get data => _$this._data ??= ListBuilder<String>();
  set data(ListBuilder<String>? data) => _$this._data = data;

  JsonObject? _properties;
  JsonObject? get properties => _$this._properties;
  set properties(JsonObject? properties) => _$this._properties = properties;

  ApiV1MoviesGet200ResponseBuilder() {
    ApiV1MoviesGet200Response._defaults(this);
  }

  ApiV1MoviesGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _data = $v.data?.toBuilder();
      _properties = $v.properties;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1MoviesGet200Response other) {
    _$v = other as _$ApiV1MoviesGet200Response;
  }

  @override
  void update(void Function(ApiV1MoviesGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1MoviesGet200Response build() => _build();

  _$ApiV1MoviesGet200Response _build() {
    _$ApiV1MoviesGet200Response _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1MoviesGet200Response._(
            success: success,
            data: _data?.build(),
            properties: properties,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        _data?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ApiV1MoviesGet200Response',
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
