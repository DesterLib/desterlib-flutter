// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_logs_get200_response_data_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1LogsGet200ResponseDataInner
    extends ApiV1LogsGet200ResponseDataInner {
  @override
  final String? timestamp;
  @override
  final String? level;
  @override
  final String? message;
  @override
  final JsonObject? meta;

  factory _$ApiV1LogsGet200ResponseDataInner([
    void Function(ApiV1LogsGet200ResponseDataInnerBuilder)? updates,
  ]) => (ApiV1LogsGet200ResponseDataInnerBuilder()..update(updates))._build();

  _$ApiV1LogsGet200ResponseDataInner._({
    this.timestamp,
    this.level,
    this.message,
    this.meta,
  }) : super._();
  @override
  ApiV1LogsGet200ResponseDataInner rebuild(
    void Function(ApiV1LogsGet200ResponseDataInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1LogsGet200ResponseDataInnerBuilder toBuilder() =>
      ApiV1LogsGet200ResponseDataInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1LogsGet200ResponseDataInner &&
        timestamp == other.timestamp &&
        level == other.level &&
        message == other.message &&
        meta == other.meta;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jc(_$hash, level.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1LogsGet200ResponseDataInner')
          ..add('timestamp', timestamp)
          ..add('level', level)
          ..add('message', message)
          ..add('meta', meta))
        .toString();
  }
}

class ApiV1LogsGet200ResponseDataInnerBuilder
    implements
        Builder<
          ApiV1LogsGet200ResponseDataInner,
          ApiV1LogsGet200ResponseDataInnerBuilder
        > {
  _$ApiV1LogsGet200ResponseDataInner? _$v;

  String? _timestamp;
  String? get timestamp => _$this._timestamp;
  set timestamp(String? timestamp) => _$this._timestamp = timestamp;

  String? _level;
  String? get level => _$this._level;
  set level(String? level) => _$this._level = level;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  JsonObject? _meta;
  JsonObject? get meta => _$this._meta;
  set meta(JsonObject? meta) => _$this._meta = meta;

  ApiV1LogsGet200ResponseDataInnerBuilder() {
    ApiV1LogsGet200ResponseDataInner._defaults(this);
  }

  ApiV1LogsGet200ResponseDataInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _timestamp = $v.timestamp;
      _level = $v.level;
      _message = $v.message;
      _meta = $v.meta;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1LogsGet200ResponseDataInner other) {
    _$v = other as _$ApiV1LogsGet200ResponseDataInner;
  }

  @override
  void update(void Function(ApiV1LogsGet200ResponseDataInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1LogsGet200ResponseDataInner build() => _build();

  _$ApiV1LogsGet200ResponseDataInner _build() {
    final _$result =
        _$v ??
        _$ApiV1LogsGet200ResponseDataInner._(
          timestamp: timestamp,
          level: level,
          message: message,
          meta: meta,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
