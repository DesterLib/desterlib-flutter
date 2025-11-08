import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for available genres
/// TODO: Replace with API call when genre endpoint is available
final genresProvider = Provider<List<String>>((ref) {
  return [
    'Action',
    'Adventure',
    'Animation',
    'Biography',
    'Comedy',
    'Crime',
    'Documentary',
    'Drama',
    'Family',
    'Fantasy',
    'History',
    'Horror',
    'Music',
    'Musical',
    'Mystery',
    'Romance',
    'Sci-Fi',
    'Sport',
    'Thriller',
    'War',
    'Western',
  ];
});
