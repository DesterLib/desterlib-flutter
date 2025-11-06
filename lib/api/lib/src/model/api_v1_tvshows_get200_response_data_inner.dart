//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/api_v1_tvshows_get200_response_data_inner_media.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_tvshows_get200_response_data_inner.g.dart';

/// ApiV1TvshowsGet200ResponseDataInner
///
/// Properties:
/// * [id] 
/// * [creator] - Creator of the TV show
/// * [network] - Network that aired the TV show
/// * [mediaId] 
/// * [media] 
@BuiltValue()
abstract class ApiV1TvshowsGet200ResponseDataInner implements Built<ApiV1TvshowsGet200ResponseDataInner, ApiV1TvshowsGet200ResponseDataInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  /// Creator of the TV show
  @BuiltValueField(wireName: r'creator')
  String? get creator;

  /// Network that aired the TV show
  @BuiltValueField(wireName: r'network')
  String? get network;

  @BuiltValueField(wireName: r'mediaId')
  String? get mediaId;

  @BuiltValueField(wireName: r'media')
  ApiV1TvshowsGet200ResponseDataInnerMedia? get media;

  ApiV1TvshowsGet200ResponseDataInner._();

  factory ApiV1TvshowsGet200ResponseDataInner([void updates(ApiV1TvshowsGet200ResponseDataInnerBuilder b)]) = _$ApiV1TvshowsGet200ResponseDataInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1TvshowsGet200ResponseDataInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1TvshowsGet200ResponseDataInner> get serializer => _$ApiV1TvshowsGet200ResponseDataInnerSerializer();
}

class _$ApiV1TvshowsGet200ResponseDataInnerSerializer implements PrimitiveSerializer<ApiV1TvshowsGet200ResponseDataInner> {
  @override
  final Iterable<Type> types = const [ApiV1TvshowsGet200ResponseDataInner, _$ApiV1TvshowsGet200ResponseDataInner];

  @override
  final String wireName = r'ApiV1TvshowsGet200ResponseDataInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1TvshowsGet200ResponseDataInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.creator != null) {
      yield r'creator';
      yield serializers.serialize(
        object.creator,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.network != null) {
      yield r'network';
      yield serializers.serialize(
        object.network,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.mediaId != null) {
      yield r'mediaId';
      yield serializers.serialize(
        object.mediaId,
        specifiedType: const FullType(String),
      );
    }
    if (object.media != null) {
      yield r'media';
      yield serializers.serialize(
        object.media,
        specifiedType: const FullType(ApiV1TvshowsGet200ResponseDataInnerMedia),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1TvshowsGet200ResponseDataInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1TvshowsGet200ResponseDataInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'creator':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.creator = valueDes;
          break;
        case r'network':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.network = valueDes;
          break;
        case r'mediaId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mediaId = valueDes;
          break;
        case r'media':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1TvshowsGet200ResponseDataInnerMedia),
          ) as ApiV1TvshowsGet200ResponseDataInnerMedia;
          result.media.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1TvshowsGet200ResponseDataInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1TvshowsGet200ResponseDataInnerBuilder();
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

