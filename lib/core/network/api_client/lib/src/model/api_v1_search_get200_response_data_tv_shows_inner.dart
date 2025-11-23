//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
// External packages
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:openapi/src/model/api_v1_search_get200_response_data_tv_shows_inner_media.dart';


part 'api_v1_search_get200_response_data_tv_shows_inner.g.dart';

/// ApiV1SearchGet200ResponseDataTvShowsInner
///
/// Properties:
/// * [id] 
/// * [creator] 
/// * [network] 
/// * [mediaId] 
/// * [media] 
@BuiltValue()
abstract class ApiV1SearchGet200ResponseDataTvShowsInner implements Built<ApiV1SearchGet200ResponseDataTvShowsInner, ApiV1SearchGet200ResponseDataTvShowsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'creator')
  String? get creator;

  @BuiltValueField(wireName: r'network')
  String? get network;

  @BuiltValueField(wireName: r'mediaId')
  String? get mediaId;

  @BuiltValueField(wireName: r'media')
  ApiV1SearchGet200ResponseDataTvShowsInnerMedia? get media;

  ApiV1SearchGet200ResponseDataTvShowsInner._();

  factory ApiV1SearchGet200ResponseDataTvShowsInner([void updates(ApiV1SearchGet200ResponseDataTvShowsInnerBuilder b)]) = _$ApiV1SearchGet200ResponseDataTvShowsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1SearchGet200ResponseDataTvShowsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1SearchGet200ResponseDataTvShowsInner> get serializer => _$ApiV1SearchGet200ResponseDataTvShowsInnerSerializer();
}

class _$ApiV1SearchGet200ResponseDataTvShowsInnerSerializer implements PrimitiveSerializer<ApiV1SearchGet200ResponseDataTvShowsInner> {
  @override
  final Iterable<Type> types = const [ApiV1SearchGet200ResponseDataTvShowsInner, _$ApiV1SearchGet200ResponseDataTvShowsInner];

  @override
  final String wireName = r'ApiV1SearchGet200ResponseDataTvShowsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1SearchGet200ResponseDataTvShowsInner object, {
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
        specifiedType: const FullType(ApiV1SearchGet200ResponseDataTvShowsInnerMedia),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1SearchGet200ResponseDataTvShowsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1SearchGet200ResponseDataTvShowsInnerBuilder result,
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
            specifiedType: const FullType(ApiV1SearchGet200ResponseDataTvShowsInnerMedia),
          ) as ApiV1SearchGet200ResponseDataTvShowsInnerMedia;
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
  ApiV1SearchGet200ResponseDataTvShowsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1SearchGet200ResponseDataTvShowsInnerBuilder();
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

