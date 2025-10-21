import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_details.dart';
import '../models/tvshow_details.dart';

class DetailsRepository {
  final String baseUrl;
  final http.Client client;

  DetailsRepository({required this.baseUrl, http.Client? client})
    : client = client ?? http.Client();

  // Fetch movie details by ID
  Future<MovieDetails> fetchMovieDetails(String id) async {
    final uri = Uri.parse('$baseUrl/movies/$id');
    final res = await client.get(uri);

    if (res.statusCode != 200) {
      throw Exception('Failed to load movie details: ${res.statusCode}');
    }

    final json = jsonDecode(res.body);
    // Extract the base URL without the /api/v1 part for constructing full URLs
    final serverBase = baseUrl.replaceAll('/api/v1', '');
    return MovieDetails.fromJson(Map<String, dynamic>.from(json), serverBase);
  }

  // Fetch TV show details by ID with seasons and episodes
  Future<TvShowDetails> fetchTvShowDetails(String id) async {
    final uri = Uri.parse('$baseUrl/tvshows/$id');
    final res = await client.get(uri);

    if (res.statusCode != 200) {
      throw Exception('Failed to load TV show details: ${res.statusCode}');
    }

    final json = jsonDecode(res.body);
    // Extract the base URL without the /api/v1 part for constructing full URLs
    final serverBase = baseUrl.replaceAll('/api/v1', '');
    return TvShowDetails.fromJson(Map<String, dynamic>.from(json), serverBase);
  }
}
