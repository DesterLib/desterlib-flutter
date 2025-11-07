import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/app/providers.dart';

/// Provider for searching media (movies and TV shows) by title using the search API
final mediaSearchProvider =
    FutureProvider.family<
      ({
        BuiltList<ApiV1SearchGet200ResponseDataMoviesInner> movies,
        BuiltList<ApiV1SearchGet200ResponseDataTvShowsInner> tvShows,
      }),
      String
    >((ref, query) async {
      if (query.isEmpty) {
        return (
          movies: BuiltList<ApiV1SearchGet200ResponseDataMoviesInner>(),
          tvShows: BuiltList<ApiV1SearchGet200ResponseDataTvShowsInner>(),
        );
      }

      final client = ref.watch(openapiClientProvider);

      try {
        // Use the new search API endpoint
        final searchApi = client.getSearchApi();
        final response = await searchApi.apiV1SearchGet(query: query);

        final data = response.data?.data;
        final movies =
            data?.movies ??
            BuiltList<ApiV1SearchGet200ResponseDataMoviesInner>();
        final tvShows =
            data?.tvShows ??
            BuiltList<ApiV1SearchGet200ResponseDataTvShowsInner>();

        return (movies: movies, tvShows: tvShows);
      } catch (e) {
        throw Exception('Failed to search media: $e');
      }
    });
