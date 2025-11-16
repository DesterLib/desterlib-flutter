import 'package:built_collection/built_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/app/providers.dart';

/// Provider for fetching movies (API returns 10 most recent)
final moviesProvider =
    FutureProvider.autoDispose<BuiltList<ApiV1MoviesGet200ResponseDataInner>>((
      ref,
    ) async {
      final client = ref.watch(openapiClientProvider);
      final moviesApi = client.getMoviesApi();

      try {
        final response = await moviesApi.apiV1MoviesGet();
        return response.data?.data ??
            BuiltList<ApiV1MoviesGet200ResponseDataInner>();
      } catch (e) {
        throw Exception('Failed to load movies: $e');
      }
    });

/// Provider for fetching TV shows (API returns 10 most recent)
final tvShowsProvider =
    FutureProvider.autoDispose<BuiltList<ApiV1TvshowsGet200ResponseDataInner>>((
      ref,
    ) async {
      final client = ref.watch(openapiClientProvider);
      final tvShowsApi = client.getTVShowsApi();

      try {
        final response = await tvShowsApi.apiV1TvshowsGet();
        return response.data?.data ??
            BuiltList<ApiV1TvshowsGet200ResponseDataInner>();
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
