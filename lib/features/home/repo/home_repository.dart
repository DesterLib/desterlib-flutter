import 'dart:convert';
import 'package:http/http.dart' as http;

class Media {
  final String id;
  final String title;
  final String type;
  final String description;
  final String posterUrl;
  final String backdropUrl;
  final DateTime? releaseDate;
  final double? rating;

  Media({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.posterUrl,
    required this.backdropUrl,
    this.releaseDate,
    this.rating,
  });

  factory Media.fromJson(Map<String, dynamic> j) => Media(
        id: j['id'] ?? '',
        title: j['title'] ?? '',
        type: j['type'] ?? '',
        description: j['description'] ?? '',
        posterUrl: j['posterUrl'] ?? '',
        backdropUrl: j['backdropUrl'] ?? '',
        releaseDate:
            j['releaseDate'] != null ? DateTime.parse(j['releaseDate']) : null,
        rating: j['rating'] != null ? (j['rating'] as num).toDouble() : null,
      );
}

class MovieItem {
  final String id;
  final int? duration;
  final String? trailerUrl;
  final String? filePath; // local path on server
  final String? fileSize;
  final DateTime? fileModifiedAt;
  final String? mediaId;
  final Media media;

  MovieItem({
    required this.id,
    this.duration,
    this.trailerUrl,
    this.filePath,
    this.fileSize,
    this.fileModifiedAt,
    this.mediaId,
    required this.media,
  });

  factory MovieItem.fromJson(Map<String, dynamic> j) => MovieItem(
        id: j['id'] ?? '',
        duration: j['duration'],
        trailerUrl: j['trailerUrl'],
        filePath: j['filePath'],
        fileSize: j['fileSize'],
        fileModifiedAt: j['fileModifiedAt'] != null
            ? DateTime.parse(j['fileModifiedAt'])
            : null,
        mediaId: j['mediaId'],
        media: Media.fromJson(Map<String, dynamic>.from(j['media'] ?? {})),
      );
}

class TvItem {
  final String id;
  final String? creator;
  final String? network;
  final String? mediaId;
  final Media media;

  TvItem({
    required this.id,
    this.creator,
    this.network,
    this.mediaId,
    required this.media,
  });

  factory TvItem.fromJson(Map<String, dynamic> j) => TvItem(
        id: j['id'] ?? '',
        creator: j['creator'],
        network: j['network'],
        mediaId: j['mediaId'],
        media: Media.fromJson(Map<String, dynamic>.from(j['media'] ?? {})),
      );
}

class HomeRepository {
  final String baseUrl;
  final http.Client client;

  HomeRepository({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();

  // Fetch movies list from /movies
  Future<List<MovieItem>> fetchMovies() async {
    final uri = Uri.parse('$baseUrl/movies');
    final res = await client.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Failed to load movies: ${res.statusCode}');
    }
    final List<dynamic> jsonList = jsonDecode(res.body);
    return jsonList
        .map((e) => MovieItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // Fetch tvshows list from /tvshows
  Future<List<TvItem>> fetchTvShows() async {
    final uri = Uri.parse('$baseUrl/tvshows');
    final res = await client.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Failed to load tv shows: ${res.statusCode}');
    }
    final List<dynamic> jsonList = jsonDecode(res.body);
    return jsonList
        .map((e) => TvItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
