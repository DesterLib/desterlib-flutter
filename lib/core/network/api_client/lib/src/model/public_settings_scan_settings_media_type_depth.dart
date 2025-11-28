//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_settings_scan_settings_media_type_depth.g.dart';

/// PublicSettingsScanSettingsMediaTypeDepth
///
/// Properties:
/// * [movie] 
/// * [tv] 
@BuiltValue()
abstract class PublicSettingsScanSettingsMediaTypeDepth implements Built<PublicSettingsScanSettingsMediaTypeDepth, PublicSettingsScanSettingsMediaTypeDepthBuilder> {
  @BuiltValueField(wireName: r'movie')
  num? get movie;

  @BuiltValueField(wireName: r'tv')
  num? get tv;

  PublicSettingsScanSettingsMediaTypeDepth._();

  factory PublicSettingsScanSettingsMediaTypeDepth([void updates(PublicSettingsScanSettingsMediaTypeDepthBuilder b)]) = _$PublicSettingsScanSettingsMediaTypeDepth;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicSettingsScanSettingsMediaTypeDepthBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicSettingsScanSettingsMediaTypeDepth> get serializer => _$PublicSettingsScanSettingsMediaTypeDepthSerializer();
}

class _$PublicSettingsScanSettingsMediaTypeDepthSerializer implements PrimitiveSerializer<PublicSettingsScanSettingsMediaTypeDepth> {
  @override
  final Iterable<Type> types = const [PublicSettingsScanSettingsMediaTypeDepth, _$PublicSettingsScanSettingsMediaTypeDepth];

  @override
  final String wireName = r'PublicSettingsScanSettingsMediaTypeDepth';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicSettingsScanSettingsMediaTypeDepth object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.movie != null) {
      yield r'movie';
      yield serializers.serialize(
        object.movie,
        specifiedType: const FullType(num),
      );
    }
    if (object.tv != null) {
      yield r'tv';
      yield serializers.serialize(
        object.tv,
        specifiedType: const FullType(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicSettingsScanSettingsMediaTypeDepth object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicSettingsScanSettingsMediaTypeDepthBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'movie':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.movie = valueDes;
          break;
        case r'tv':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.tv = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicSettingsScanSettingsMediaTypeDepth deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicSettingsScanSettingsMediaTypeDepthBuilder();
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

