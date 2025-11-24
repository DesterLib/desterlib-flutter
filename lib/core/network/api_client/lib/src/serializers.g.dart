// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers =
    (Serializers().toBuilder()
          ..add(ApiV1LibraryDelete200Response.serializer)
          ..add(ApiV1LibraryDelete200ResponseData.serializer)
          ..add(ApiV1LibraryDelete400Response.serializer)
          ..add(ApiV1LibraryDelete500Response.serializer)
          ..add(ApiV1LibraryDeleteRequest.serializer)
          ..add(ApiV1LibraryGet200Response.serializer)
          ..add(ApiV1LibraryPut200Response.serializer)
          ..add(ApiV1LibraryPut200ResponseData.serializer)
          ..add(ApiV1LibraryPut400Response.serializer)
          ..add(ApiV1LibraryPut404Response.serializer)
          ..add(ApiV1LibraryPutRequest.serializer)
          ..add(ApiV1LibraryPutRequestLibraryTypeEnum.serializer)
          ..add(ApiV1LogsDelete200Response.serializer)
          ..add(ApiV1LogsGet200Response.serializer)
          ..add(ApiV1LogsGet200ResponseDataInner.serializer)
          ..add(ApiV1LogsGet500Response.serializer)
          ..add(ApiV1MoviesGet200Response.serializer)
          ..add(ApiV1MoviesGet200ResponseDataInner.serializer)
          ..add(ApiV1MoviesGet200ResponseDataInnerMedia.serializer)
          ..add(ApiV1MoviesGet200ResponseDataInnerMediaTypeEnum.serializer)
          ..add(ApiV1MoviesGet500Response.serializer)
          ..add(ApiV1MoviesIdGet200Response.serializer)
          ..add(ApiV1MoviesIdGet200ResponseData.serializer)
          ..add(ApiV1MoviesIdGet200ResponseDataMedia.serializer)
          ..add(ApiV1MoviesIdGet200ResponseDataMediaTypeEnum.serializer)
          ..add(ApiV1MoviesIdGet400Response.serializer)
          ..add(ApiV1MoviesIdGet404Response.serializer)
          ..add(ApiV1MoviesIdGet500Response.serializer)
          ..add(ApiV1ScanCleanupPost200Response.serializer)
          ..add(ApiV1ScanCleanupPost200ResponseData.serializer)
          ..add(ApiV1ScanPathPost200Response.serializer)
          ..add(ApiV1ScanPathPost200ResponseData.serializer)
          ..add(ApiV1ScanPathPost200ResponseDataCacheStats.serializer)
          ..add(ApiV1ScanPathPost400Response.serializer)
          ..add(ApiV1ScanPathPost500Response.serializer)
          ..add(ApiV1ScanPathPostRequest.serializer)
          ..add(ApiV1ScanPathPostRequestOptions.serializer)
          ..add(ApiV1ScanPathPostRequestOptionsMediaTypeEnum.serializer)
          ..add(ApiV1ScanResumeScanJobIdPost202Response.serializer)
          ..add(ApiV1ScanResumeScanJobIdPost202ResponseData.serializer)
          ..add(ApiV1SearchGet200Response.serializer)
          ..add(ApiV1SearchGet200ResponseData.serializer)
          ..add(ApiV1SearchGet200ResponseDataMoviesInner.serializer)
          ..add(ApiV1SearchGet200ResponseDataTvShowsInner.serializer)
          ..add(ApiV1SearchGet200ResponseDataTvShowsInnerMedia.serializer)
          ..add(
            ApiV1SearchGet200ResponseDataTvShowsInnerMediaTypeEnum.serializer,
          )
          ..add(ApiV1SearchGet400Response.serializer)
          ..add(ApiV1SearchGet500Response.serializer)
          ..add(ApiV1SettingsFirstRunCompletePost200Response.serializer)
          ..add(ApiV1SettingsFirstRunCompletePost500Response.serializer)
          ..add(ApiV1SettingsGet200Response.serializer)
          ..add(ApiV1SettingsGet500Response.serializer)
          ..add(ApiV1SettingsPut200Response.serializer)
          ..add(ApiV1SettingsPut500Response.serializer)
          ..add(ApiV1StreamIdGet400Response.serializer)
          ..add(ApiV1StreamIdGet404Response.serializer)
          ..add(ApiV1StreamIdGet416Response.serializer)
          ..add(ApiV1StreamIdGet500Response.serializer)
          ..add(ApiV1TvshowsGet200Response.serializer)
          ..add(ApiV1TvshowsGet200ResponseDataInner.serializer)
          ..add(ApiV1TvshowsGet200ResponseDataInnerMedia.serializer)
          ..add(ApiV1TvshowsGet200ResponseDataInnerMediaTypeEnum.serializer)
          ..add(ApiV1TvshowsGet500Response.serializer)
          ..add(ApiV1TvshowsIdGet200Response.serializer)
          ..add(ApiV1TvshowsIdGet200ResponseData.serializer)
          ..add(ApiV1TvshowsIdGet200ResponseDataSeasonsInner.serializer)
          ..add(
            ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner
                .serializer,
          )
          ..add(ApiV1TvshowsIdGet400Response.serializer)
          ..add(ApiV1TvshowsIdGet404Response.serializer)
          ..add(ApiV1TvshowsIdGet500Response.serializer)
          ..add(HealthResponse.serializer)
          ..add(ModelLibrary.serializer)
          ..add(ModelLibraryLibraryTypeEnum.serializer)
          ..add(PublicSettings.serializer)
          ..add(UpdateSettingsRequest.serializer)
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(ApiV1LogsGet200ResponseDataInner),
            ]),
            () => ListBuilder<ApiV1LogsGet200ResponseDataInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(ApiV1MoviesGet200ResponseDataInner),
            ]),
            () => ListBuilder<ApiV1MoviesGet200ResponseDataInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(ApiV1SearchGet200ResponseDataMoviesInner),
            ]),
            () => ListBuilder<ApiV1SearchGet200ResponseDataMoviesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(ApiV1SearchGet200ResponseDataTvShowsInner),
            ]),
            () => ListBuilder<ApiV1SearchGet200ResponseDataTvShowsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(ApiV1TvshowsGet200ResponseDataInner),
            ]),
            () => ListBuilder<ApiV1TvshowsGet200ResponseDataInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(ApiV1TvshowsIdGet200ResponseDataSeasonsInner),
            ]),
            () => ListBuilder<ApiV1TvshowsIdGet200ResponseDataSeasonsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner,
              ),
            ]),
            () =>
                ListBuilder<
                  ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(ModelLibrary)]),
            () => ListBuilder<ModelLibrary>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          ))
        .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
