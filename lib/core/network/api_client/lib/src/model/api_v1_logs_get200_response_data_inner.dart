//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_logs_get200_response_data_inner.g.dart';

/// ApiV1LogsGet200ResponseDataInner
///
/// Properties:
/// * [timestamp] 
/// * [level] 
/// * [message] 
/// * [meta] 
@BuiltValue()
abstract class ApiV1LogsGet200ResponseDataInner implements Built<ApiV1LogsGet200ResponseDataInner, ApiV1LogsGet200ResponseDataInnerBuilder> {
  @BuiltValueField(wireName: r'timestamp')
  String? get timestamp;

  @BuiltValueField(wireName: r'level')
  String? get level;

  @BuiltValueField(wireName: r'message')
  String? get message;

  @BuiltValueField(wireName: r'meta')
  JsonObject? get meta;

  ApiV1LogsGet200ResponseDataInner._();

  factory ApiV1LogsGet200ResponseDataInner([void updates(ApiV1LogsGet200ResponseDataInnerBuilder b)]) = _$ApiV1LogsGet200ResponseDataInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1LogsGet200ResponseDataInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1LogsGet200ResponseDataInner> get serializer => _$ApiV1LogsGet200ResponseDataInnerSerializer();
}

class _$ApiV1LogsGet200ResponseDataInnerSerializer implements PrimitiveSerializer<ApiV1LogsGet200ResponseDataInner> {
  @override
  final Iterable<Type> types = const [ApiV1LogsGet200ResponseDataInner, _$ApiV1LogsGet200ResponseDataInner];

  @override
  final String wireName = r'ApiV1LogsGet200ResponseDataInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1LogsGet200ResponseDataInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.timestamp != null) {
      yield r'timestamp';
      yield serializers.serialize(
        object.timestamp,
        specifiedType: const FullType(String),
      );
    }
    if (object.level != null) {
      yield r'level';
      yield serializers.serialize(
        object.level,
        specifiedType: const FullType(String),
      );
    }
    if (object.message != null) {
      yield r'message';
      yield serializers.serialize(
        object.message,
        specifiedType: const FullType(String),
      );
    }
    if (object.meta != null) {
      yield r'meta';
      yield serializers.serialize(
        object.meta,
        specifiedType: const FullType.nullable(JsonObject),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1LogsGet200ResponseDataInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1LogsGet200ResponseDataInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'timestamp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.timestamp = valueDes;
          break;
        case r'level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.level = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.meta = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1LogsGet200ResponseDataInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1LogsGet200ResponseDataInnerBuilder();
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

