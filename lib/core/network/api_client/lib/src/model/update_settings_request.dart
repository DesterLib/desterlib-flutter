//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/update_settings_request_scan_settings.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_settings_request.g.dart';

/// UpdateSettingsRequest
///
/// Properties:
/// * [tmdbApiKey] - The Movie Database (TMDB) API key
/// * [port] - Server port number
/// * [enableRouteGuards] - Enable/disable authentication route guards
/// * [firstRun] - Whether this is the first run (usually managed via /first-run-complete)
/// * [scanSettings] 
@BuiltValue()
abstract class UpdateSettingsRequest implements Built<UpdateSettingsRequest, UpdateSettingsRequestBuilder> {
  /// The Movie Database (TMDB) API key
  @BuiltValueField(wireName: r'tmdbApiKey')
  String? get tmdbApiKey;

  /// Server port number
  @BuiltValueField(wireName: r'port')
  num? get port;

  /// Enable/disable authentication route guards
  @BuiltValueField(wireName: r'enableRouteGuards')
  bool? get enableRouteGuards;

  /// Whether this is the first run (usually managed via /first-run-complete)
  @BuiltValueField(wireName: r'firstRun')
  bool? get firstRun;

  @BuiltValueField(wireName: r'scanSettings')
  UpdateSettingsRequestScanSettings? get scanSettings;

  UpdateSettingsRequest._();

  factory UpdateSettingsRequest([void updates(UpdateSettingsRequestBuilder b)]) = _$UpdateSettingsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateSettingsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateSettingsRequest> get serializer => _$UpdateSettingsRequestSerializer();
}

class _$UpdateSettingsRequestSerializer implements PrimitiveSerializer<UpdateSettingsRequest> {
  @override
  final Iterable<Type> types = const [UpdateSettingsRequest, _$UpdateSettingsRequest];

  @override
  final String wireName = r'UpdateSettingsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateSettingsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.tmdbApiKey != null) {
      yield r'tmdbApiKey';
      yield serializers.serialize(
        object.tmdbApiKey,
        specifiedType: const FullType(String),
      );
    }
    if (object.port != null) {
      yield r'port';
      yield serializers.serialize(
        object.port,
        specifiedType: const FullType(num),
      );
    }
    if (object.enableRouteGuards != null) {
      yield r'enableRouteGuards';
      yield serializers.serialize(
        object.enableRouteGuards,
        specifiedType: const FullType(bool),
      );
    }
    if (object.firstRun != null) {
      yield r'firstRun';
      yield serializers.serialize(
        object.firstRun,
        specifiedType: const FullType(bool),
      );
    }
    if (object.scanSettings != null) {
      yield r'scanSettings';
      yield serializers.serialize(
        object.scanSettings,
        specifiedType: const FullType(UpdateSettingsRequestScanSettings),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateSettingsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateSettingsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tmdbApiKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tmdbApiKey = valueDes;
          break;
        case r'port':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.port = valueDes;
          break;
        case r'enableRouteGuards':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enableRouteGuards = valueDes;
          break;
        case r'firstRun':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.firstRun = valueDes;
          break;
        case r'scanSettings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UpdateSettingsRequestScanSettings),
          ) as UpdateSettingsRequestScanSettings;
          result.scanSettings.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateSettingsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateSettingsRequestBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

