import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dester/app/providers.dart';
import 'package:openapi/openapi.dart';
import '../widgets/media_data.dart';

/// Unified result containing both basic media info and TV show details (if applicable)
class MediaDetailResult {
  final MediaData mediaData;
  final ApiV1TvshowsIdGet200ResponseData? tvShowDetails;

  const MediaDetailResult({required this.mediaData, this.tvShowDetails});
}

/// Single provider that fetches all media details in one call
/// For movies: returns MediaData only
/// For TV shows: returns MediaData + seasons/episodes data
final mediaDetailProvider =
    FutureProvider.family<MediaDetailResult?, (String, String?)>((
      ref,
      params,
    ) async {
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
              return MediaDetailResult(
                mediaData: MediaData(
                  id: movie.id ?? id,
                  title: media.title ?? 'Unknown Title',
                  year: media.releaseDate?.year.toString() ?? '',
                  duration: movie.duration != null
                      ? '${movie.duration}min'
                      : '',
                  rating: media.rating?.toStringAsFixed(1) ?? '',
                  genres: [],
                  description: media.description ?? '',
                  director: '',
                  cast: [],
                  posterUrl: media.posterUrl,
                  backdropUrl: media.backdropUrl,
                ),
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
              return MediaDetailResult(
                mediaData: MediaData(
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
                ),
                tvShowDetails: tvShow,
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
          return MediaDetailResult(
            mediaData: MediaData(
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
            ),
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
          return MediaDetailResult(
            mediaData: MediaData(
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
            ),
            tvShowDetails: tvShow,
          );
        }
      } catch (e) {
        // Not a TV show either
      }

      return null;
    });
