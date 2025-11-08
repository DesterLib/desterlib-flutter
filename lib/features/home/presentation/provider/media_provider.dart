import 'package:built_collection/built_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/app/providers.dart';

/// Provider for fetching movies (limited to 10 items)
final moviesProvider =
    FutureProvider.autoDispose<BuiltList<ApiV1MoviesGet200ResponseDataInner>>((
      ref,
    ) async {
      final client = ref.watch(openapiClientProvider);
      final moviesApi = client.getMoviesApi();

      try {
        final response = await moviesApi.apiV1MoviesGet();
        final movies =
            response.data?.data ??
            BuiltList<ApiV1MoviesGet200ResponseDataInner>();

        // Limit to 10 items
        return movies.length > 10
            ? BuiltList<ApiV1MoviesGet200ResponseDataInner>(movies.take(10))
            : movies;
      } catch (e) {
        throw Exception('Failed to load movies: $e');
      }
    });

/// Provider for fetching TV shows (limited to 10 items)
final tvShowsProvider =
    FutureProvider.autoDispose<BuiltList<ApiV1TvshowsGet200ResponseDataInner>>((
      ref,
    ) async {
      final client = ref.watch(openapiClientProvider);
      final tvShowsApi = client.getTVShowsApi();

      try {
        final response = await tvShowsApi.apiV1TvshowsGet();
        final tvShows =
            response.data?.data ??
            BuiltList<ApiV1TvshowsGet200ResponseDataInner>();

        // Limit to 10 items
        return tvShows.length > 10
            ? BuiltList<ApiV1TvshowsGet200ResponseDataInner>(tvShows.take(10))
            : tvShows;
      } catch (e) {
        throw Exception('Failed to load TV shows: $e');
      }
    });

/// Provider to refresh both movies and TV shows
final refreshMediaProvider = Provider<void Function()>((ref) {
  return () {
    ref.invalidate(moviesProvider);
    ref.invalidate(tvShowsProvider);
  };
});
