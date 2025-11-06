import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dester/app/providers.dart';
import 'package:openapi/openapi.dart';
import '../widgets/media_data.dart';

/// Provider that fetches media by ID and optional type (movie or TV show)
/// If mediaType is provided, it will only try that specific type, avoiding unnecessary API calls
final mediaDetailProvider =
    FutureProvider.family<MediaData?, (String, String?)>((ref, params) async {
      final (id, mediaType) = params;
      final client = ref.watch(openapiClientProvider);

      // If mediaType is provided, fetch only that type
      if (mediaType != null) {
        if (mediaType.toUpperCase() == 'MOVIE') {
          try {
            final moviesApi = client.getMoviesApi();
            final response = await moviesApi.apiV1MoviesIdGet(id: id);
            final movie = response.data?.data;

            if (movie != null && movie.media != null) {
              final media = movie.media!;
              return MediaData(
                id: movie.id ?? id,
                title: media.title ?? 'Unknown Title',
                year: media.releaseDate?.year.toString() ?? '',
                duration: movie.duration != null ? '${movie.duration}min' : '',
                rating: media.rating?.toStringAsFixed(1) ?? '',
                genres: [],
                description: media.description ?? '',
                director: '',
                cast: [],
                posterUrl: media.posterUrl,
                backdropUrl: media.backdropUrl,
              );
            }
          } catch (e) {
            // Failed to fetch movie
          }
          return null;
        } else if (mediaType.toUpperCase() == 'TV_SHOW') {
          try {
            final tvShowsApi = client.getTVShowsApi();
            final response = await tvShowsApi.apiV1TvshowsIdGet(id: id);
            final tvShow = response.data?.data;

            if (tvShow != null && tvShow.media != null) {
              final media = tvShow.media!;
              return MediaData(
                id: tvShow.id ?? id,
                title: media.title ?? 'Unknown Title',
                year: media.releaseDate?.year.toString() ?? '',
                duration: '',
                rating: media.rating?.toStringAsFixed(1) ?? '',
                genres: [],
                description: media.description ?? '',
                director: tvShow.creator ?? '',
                cast: [],
                posterUrl: media.posterUrl,
                backdropUrl: media.backdropUrl,
              );
            }
          } catch (e) {
            // Failed to fetch TV show
          }
          return null;
        }
      }

      // Fallback: Try to fetch as a movie first, then TV show
      try {
        final moviesApi = client.getMoviesApi();
        final response = await moviesApi.apiV1MoviesIdGet(id: id);
        final movie = response.data?.data;

        if (movie != null && movie.media != null) {
          final media = movie.media!;
          return MediaData(
            id: movie.id ?? id,
            title: media.title ?? 'Unknown Title',
            year: media.releaseDate?.year.toString() ?? '',
            duration: movie.duration != null ? '${movie.duration}min' : '',
            rating: media.rating?.toStringAsFixed(1) ?? '',
            genres: [],
            description: media.description ?? '',
            director: '',
            cast: [],
            posterUrl: media.posterUrl,
            backdropUrl: media.backdropUrl,
          );
        }
      } catch (e) {
        // Not a movie, continue to try TV show
      }

      // Try to fetch as a TV show
      try {
        final tvShowsApi = client.getTVShowsApi();
        final response = await tvShowsApi.apiV1TvshowsIdGet(id: id);
        final tvShow = response.data?.data;

        if (tvShow != null && tvShow.media != null) {
          final media = tvShow.media!;
          return MediaData(
            id: tvShow.id ?? id,
            title: media.title ?? 'Unknown Title',
            year: media.releaseDate?.year.toString() ?? '',
            duration: '',
            rating: media.rating?.toStringAsFixed(1) ?? '',
            genres: [],
            description: media.description ?? '',
            director: tvShow.creator ?? '',
            cast: [],
            posterUrl: media.posterUrl,
            backdropUrl: media.backdropUrl,
          );
        }
      } catch (e) {
        // Not a TV show either
      }

      return null;
    });

/// Provider for TV show details including seasons and episodes
/// Returns null if the ID is not a TV show
final tvShowDetailsProvider =
    FutureProvider.family<ApiV1TvshowsIdGet200ResponseData?, String>((
      ref,
      id,
    ) async {
      final client = ref.watch(openapiClientProvider);
      final tvShowsApi = client.getTVShowsApi();

      try {
        final response = await tvShowsApi.apiV1TvshowsIdGet(id: id);
        return response.data?.data;
      } catch (e) {
        return null;
      }
    });
