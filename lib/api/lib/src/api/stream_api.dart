//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:openapi/src/api_util.dart';
import 'package:openapi/src/model/api_v1_stream_id_get400_response.dart';
import 'package:openapi/src/model/api_v1_stream_id_get404_response.dart';
import 'package:openapi/src/model/api_v1_stream_id_get416_response.dart';
import 'package:openapi/src/model/api_v1_stream_id_get500_response.dart';

class StreamApi {

  final Dio _dio;

  final Serializers _serializers;

  const StreamApi(this._dio, this._serializers);

  /// Stream any media file by ID with byte-range support
  /// Streams any media file (movie, TV episode, music, comic) with proper HTTP range request support. This centralized endpoint can handle any media type stored in the database. Supports seeking, partial content delivery, and proper streaming headers for video/audio playback. 
  ///
  /// Parameters:
  /// * [id] - The media file ID (can be movie ID, episode ID, music ID, or comic ID)
  /// * [range] - Byte range request (e.g., \"bytes=0-1023\")
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future]
  /// Throws [DioException] if API call or serialization fails
  Future<Response<void>> apiV1StreamIdGet({ 
    required String id,
    String? range,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/stream/{id}'.replaceAll('{' r'id' '}', encodeQueryParameter(_serializers, id, const FullType(String)).toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        if (range != null) r'Range': range,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    return _response;
  }

}
