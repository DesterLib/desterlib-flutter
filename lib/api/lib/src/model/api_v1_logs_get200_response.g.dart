// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_logs_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1LogsGet200Response extends ApiV1LogsGet200Response {
  @override
  final bool? success;
  @override
  final BuiltList<ApiV1LogsGet200ResponseDataInner>? data;

  factory _$ApiV1LogsGet200Response([
    void Function(ApiV1LogsGet200ResponseBuilder)? updates,
  ]) => (ApiV1LogsGet200ResponseBuilder()..update(updates))._build();

  _$ApiV1LogsGet200Response._({this.success, this.data}) : super._();
  @override
  ApiV1LogsGet200Response rebuild(
    void Function(ApiV1LogsGet200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1LogsGet200ResponseBuilder toBuilder() =>
      ApiV1LogsGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1LogsGet200Response &&
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
    return (newBuiltValueToStringHelper(r'ApiV1LogsGet200Response')
          ..add('success', success)
          ..add('data', data))
        .toString();
  }
}

class ApiV1LogsGet200ResponseBuilder
    implements
        Builder<ApiV1LogsGet200Response, ApiV1LogsGet200ResponseBuilder> {
  _$ApiV1LogsGet200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  ListBuilder<ApiV1LogsGet200ResponseDataInner>? _data;
  ListBuilder<ApiV1LogsGet200ResponseDataInner> get data =>
      _$this._data ??= ListBuilder<ApiV1LogsGet200ResponseDataInner>();
  set data(ListBuilder<ApiV1LogsGet200ResponseDataInner>? data) =>
      _$this._data = data;

  ApiV1LogsGet200ResponseBuilder() {
    ApiV1LogsGet200Response._defaults(this);
  }

  ApiV1LogsGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _data = $v.data?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1LogsGet200Response other) {
    _$v = other as _$ApiV1LogsGet200Response;
  }

  @override
  void update(void Function(ApiV1LogsGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1LogsGet200Response build() => _build();

  _$ApiV1LogsGet200Response _build() {
    _$ApiV1LogsGet200Response _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1LogsGet200Response._(success: success, data: _data?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        _data?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ApiV1LogsGet200Response',
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
