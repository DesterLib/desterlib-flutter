//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:openapi/src/model/api_v1_scan_path_post200_response.dart';
import 'package:openapi/src/model/api_v1_scan_path_post400_response.dart';
import 'package:openapi/src/model/api_v1_scan_path_post500_response.dart';
import 'package:openapi/src/model/api_v1_scan_path_post_request.dart';

class ScanApi {

  final Dio _dio;

  final Serializers _serializers;

  const ScanApi(this._dio, this._serializers);

  /// Scan a local file path and fetch TMDB metadata
  /// Scans a local directory path and returns discovered media files with TMDB metadata. - Automatically fetches metadata from TMDB using the API key from environment variables - Extracts IDs from filenames and folder names (supports {tmdb-XXX}, {imdb-ttXXX}, {tvdb-XXX} formats) - Stores media information in the database with proper relationships - Supports both movies and TV shows 
  ///
  /// Parameters:
  /// * [apiV1ScanPathPostRequest] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ApiV1ScanPathPost200Response] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ApiV1ScanPathPost200Response>> apiV1ScanPathPost({ 
    required ApiV1ScanPathPostRequest apiV1ScanPathPostRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/scan/path';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(ApiV1ScanPathPostRequest);
      _bodyData = _serializers.serialize(apiV1ScanPathPostRequest, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ApiV1ScanPathPost200Response? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ApiV1ScanPathPost200Response),
      ) as ApiV1ScanPathPost200Response;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ApiV1ScanPathPost200Response>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

}
