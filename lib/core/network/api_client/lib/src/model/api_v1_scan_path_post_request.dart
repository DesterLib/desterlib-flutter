//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
// External packages
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:openapi/src/model/api_v1_scan_path_post_request_options.dart';


part 'api_v1_scan_path_post_request.g.dart';

/// ApiV1ScanPathPostRequest
///
/// Properties:
/// * [path] - Local file system path to scan
/// * [options] 
@BuiltValue()
abstract class ApiV1ScanPathPostRequest implements Built<ApiV1ScanPathPostRequest, ApiV1ScanPathPostRequestBuilder> {
  /// Local file system path to scan
  @BuiltValueField(wireName: r'path')
  String get path;

  @BuiltValueField(wireName: r'options')
  ApiV1ScanPathPostRequestOptions? get options;

  ApiV1ScanPathPostRequest._();

  factory ApiV1ScanPathPostRequest([void updates(ApiV1ScanPathPostRequestBuilder b)]) = _$ApiV1ScanPathPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1ScanPathPostRequestBuilder b) => b
      ..path = '/Volumes/External/Library/Media/Shows/Anime';

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1ScanPathPostRequest> get serializer => _$ApiV1ScanPathPostRequestSerializer();
}

class _$ApiV1ScanPathPostRequestSerializer implements PrimitiveSerializer<ApiV1ScanPathPostRequest> {
  @override
  final Iterable<Type> types = const [ApiV1ScanPathPostRequest, _$ApiV1ScanPathPostRequest];

  @override
  final String wireName = r'ApiV1ScanPathPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1ScanPathPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'path';
    yield serializers.serialize(
      object.path,
      specifiedType: const FullType(String),
    );
    if (object.options != null) {
      yield r'options';
      yield serializers.serialize(
        object.options,
        specifiedType: const FullType(ApiV1ScanPathPostRequestOptions),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1ScanPathPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1ScanPathPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.path = valueDes;
          break;
        case r'options':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1ScanPathPostRequestOptions),
          ) as ApiV1ScanPathPostRequestOptions;
          result.options.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1ScanPathPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1ScanPathPostRequestBuilder();
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

