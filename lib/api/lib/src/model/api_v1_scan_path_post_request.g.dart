// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_scan_path_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1ScanPathPostRequest extends ApiV1ScanPathPostRequest {
  @override
  final String path;
  @override
  final ApiV1ScanPathPostRequestOptions? options;

  factory _$ApiV1ScanPathPostRequest([
    void Function(ApiV1ScanPathPostRequestBuilder)? updates,
  ]) => (ApiV1ScanPathPostRequestBuilder()..update(updates))._build();

  _$ApiV1ScanPathPostRequest._({required this.path, this.options}) : super._();
  @override
  ApiV1ScanPathPostRequest rebuild(
    void Function(ApiV1ScanPathPostRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1ScanPathPostRequestBuilder toBuilder() =>
      ApiV1ScanPathPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1ScanPathPostRequest &&
        path == other.path &&
        options == other.options;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, path.hashCode);
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1ScanPathPostRequest')
          ..add('path', path)
          ..add('options', options))
        .toString();
  }
}

class ApiV1ScanPathPostRequestBuilder
    implements
        Builder<ApiV1ScanPathPostRequest, ApiV1ScanPathPostRequestBuilder> {
  _$ApiV1ScanPathPostRequest? _$v;

  String? _path;
  String? get path => _$this._path;
  set path(String? path) => _$this._path = path;

  ApiV1ScanPathPostRequestOptionsBuilder? _options;
  ApiV1ScanPathPostRequestOptionsBuilder get options =>
      _$this._options ??= ApiV1ScanPathPostRequestOptionsBuilder();
  set options(ApiV1ScanPathPostRequestOptionsBuilder? options) =>
      _$this._options = options;

  ApiV1ScanPathPostRequestBuilder() {
    ApiV1ScanPathPostRequest._defaults(this);
  }

  ApiV1ScanPathPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _path = $v.path;
      _options = $v.options?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1ScanPathPostRequest other) {
    _$v = other as _$ApiV1ScanPathPostRequest;
  }

  @override
  void update(void Function(ApiV1ScanPathPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1ScanPathPostRequest build() => _build();

  _$ApiV1ScanPathPostRequest _build() {
    _$ApiV1ScanPathPostRequest _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1ScanPathPostRequest._(
            path: BuiltValueNullFieldError.checkNotNull(
              path,
              r'ApiV1ScanPathPostRequest',
              'path',
            ),
            options: _options?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'options';
        _options?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ApiV1ScanPathPostRequest',
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
