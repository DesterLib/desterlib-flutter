//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:openapi/src/date_serializer.dart';
import 'package:openapi/src/model/date.dart';

import 'package:openapi/src/model/api_v1_library_delete200_response.dart';
import 'package:openapi/src/model/api_v1_library_delete200_response_data.dart';
import 'package:openapi/src/model/api_v1_library_delete400_response.dart';
import 'package:openapi/src/model/api_v1_library_delete500_response.dart';
import 'package:openapi/src/model/api_v1_library_delete_request.dart';
import 'package:openapi/src/model/api_v1_library_get200_response.dart';
import 'package:openapi/src/model/api_v1_library_put200_response.dart';
import 'package:openapi/src/model/api_v1_library_put200_response_data.dart';
import 'package:openapi/src/model/api_v1_library_put400_response.dart';
import 'package:openapi/src/model/api_v1_library_put404_response.dart';
import 'package:openapi/src/model/api_v1_library_put_request.dart';
import 'package:openapi/src/model/api_v1_movies_get200_response.dart';
import 'package:openapi/src/model/api_v1_movies_get500_response.dart';
import 'package:openapi/src/model/api_v1_scan_path_post200_response.dart';
import 'package:openapi/src/model/api_v1_scan_path_post200_response_data.dart';
import 'package:openapi/src/model/api_v1_scan_path_post200_response_data_cache_stats.dart';
import 'package:openapi/src/model/api_v1_scan_path_post400_response.dart';
import 'package:openapi/src/model/api_v1_scan_path_post500_response.dart';
import 'package:openapi/src/model/api_v1_scan_path_post_request.dart';
import 'package:openapi/src/model/api_v1_scan_path_post_request_options.dart';
import 'package:openapi/src/model/api_v1_stream_id_get400_response.dart';
import 'package:openapi/src/model/api_v1_stream_id_get404_response.dart';
import 'package:openapi/src/model/api_v1_stream_id_get416_response.dart';
import 'package:openapi/src/model/api_v1_stream_id_get500_response.dart';
import 'package:openapi/src/model/api_v1_tvshows_get500_response.dart';
import 'package:openapi/src/model/health_response.dart';
import 'package:openapi/src/model/model_library.dart';

part 'serializers.g.dart';

@SerializersFor([
  ApiV1LibraryDelete200Response,
  ApiV1LibraryDelete200ResponseData,
  ApiV1LibraryDelete400Response,
  ApiV1LibraryDelete500Response,
  ApiV1LibraryDeleteRequest,
  ApiV1LibraryGet200Response,
  ApiV1LibraryPut200Response,
  ApiV1LibraryPut200ResponseData,
  ApiV1LibraryPut400Response,
  ApiV1LibraryPut404Response,
  ApiV1LibraryPutRequest,
  ApiV1MoviesGet200Response,
  ApiV1MoviesGet500Response,
  ApiV1ScanPathPost200Response,
  ApiV1ScanPathPost200ResponseData,
  ApiV1ScanPathPost200ResponseDataCacheStats,
  ApiV1ScanPathPost400Response,
  ApiV1ScanPathPost500Response,
  ApiV1ScanPathPostRequest,
  ApiV1ScanPathPostRequestOptions,
  ApiV1StreamIdGet400Response,
  ApiV1StreamIdGet404Response,
  ApiV1StreamIdGet416Response,
  ApiV1StreamIdGet500Response,
  ApiV1TvshowsGet500Response,
  HealthResponse,
  ModelLibrary,
])
Serializers serializers = (_$serializers.toBuilder()
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer())
    ).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
