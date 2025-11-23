//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
// External packages
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';


part 'public_settings.g.dart';

/// PublicSettings
///
/// Properties:
/// * [tmdbApiKey] - The Movie Database (TMDB) API key for fetching metadata
/// * [port] - Server port number
/// * [enableRouteGuards] - Whether to enable authentication route guards
/// * [firstRun] - Indicates if this is the first run of the application
@BuiltValue()
abstract class PublicSettings implements Built<PublicSettings, PublicSettingsBuilder> {
  /// The Movie Database (TMDB) API key for fetching metadata
  @BuiltValueField(wireName: r'tmdbApiKey')
  String? get tmdbApiKey;

  /// Server port number
  @BuiltValueField(wireName: r'port')
  num? get port;

  /// Whether to enable authentication route guards
  @BuiltValueField(wireName: r'enableRouteGuards')
  bool? get enableRouteGuards;

  /// Indicates if this is the first run of the application
  @BuiltValueField(wireName: r'firstRun')
  bool? get firstRun;

  PublicSettings._();

  factory PublicSettings([void updates(PublicSettingsBuilder b)]) = _$PublicSettings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicSettingsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicSettings> get serializer => _$PublicSettingsSerializer();
}

class _$PublicSettingsSerializer implements PrimitiveSerializer<PublicSettings> {
  @override
  final Iterable<Type> types = const [PublicSettings, _$PublicSettings];

  @override
  final String wireName = r'PublicSettings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicSettings object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicSettings object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicSettingsBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicSettings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicSettingsBuilder();
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

