import 'dart:convert';
import 'package:http/http.dart' as http;

class AppSettings {
  final String? tmdbApiKey;
  final int? port;
  final bool? enableRouteGuards;

  AppSettings({this.tmdbApiKey, this.port, this.enableRouteGuards});

  factory AppSettings.fromJson(Map<String, dynamic> j) => AppSettings(
    tmdbApiKey: j['tmdbApiKey'],
    port: j['port'],
    enableRouteGuards: j['enableRouteGuards'],
  );

  Map<String, dynamic> toJson() => {
    if (tmdbApiKey != null) 'tmdbApiKey': tmdbApiKey,
    if (port != null) 'port': port,
    if (enableRouteGuards != null) 'enableRouteGuards': enableRouteGuards,
  };
}

class Library {
  final String id;
  final String name;
  final String path;
  final String type; // 'MOVIE' or 'TV_SHOW'
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? mediaCount;

  Library({
    required this.id,
    required this.name,
    required this.path,
    required this.type,
    this.createdAt,
    this.updatedAt,
    this.mediaCount,
  });

  factory Library.fromJson(Map<String, dynamic> j) => Library(
    id: j['id'] ?? '',
    name: j['name'] ?? '',
    path: j['path'] ?? '',
    type: j['type'] ?? 'MOVIE',
    createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt']) : null,
    updatedAt: j['updatedAt'] != null ? DateTime.parse(j['updatedAt']) : null,
    mediaCount: j['mediaCount'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'path': path,
    'type': type,
  };
}

class SettingsRepository {
  final String baseUrl;
  final http.Client client;

  SettingsRepository({required this.baseUrl, http.Client? client})
    : client = client ?? http.Client();

  // Fetch all libraries
  Future<List<Library>> fetchLibraries() async {
    final uri = Uri.parse('$baseUrl/library');
    final res = await client.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Failed to load libraries: ${res.statusCode}');
    }
    final List<dynamic> jsonList = jsonDecode(res.body);
    return jsonList
        .map((e) => Library.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // Create a new library (via scan endpoint which auto-creates the library)
  Future<Map<String, dynamic>> createLibrary({
    required String name,
    required String path,
    required String type,
  }) async {
    final uri = Uri.parse('$baseUrl/scan/path');
    final mediaType = type == 'MOVIE' ? 'movie' : 'tv';

    final res = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'path': path,
        'options': {'libraryName': name, 'mediaType': mediaType},
      }),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(
        'Failed to create library: ${res.statusCode} - ${res.body}',
      );
    }
    return jsonDecode(res.body);
  }

  // Update an existing library
  Future<Library> updateLibrary({
    required String id,
    required String name,
    required String path,
    required String type,
  }) async {
    final uri = Uri.parse('$baseUrl/library/$id');
    final res = await client.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'path': path, 'type': type}),
    );
    if (res.statusCode != 200) {
      throw Exception(
        'Failed to update library: ${res.statusCode} - ${res.body}',
      );
    }
    return Library.fromJson(jsonDecode(res.body));
  }

  // Delete a library
  Future<void> deleteLibrary(String id) async {
    final uri = Uri.parse('$baseUrl/library');
    final res = await client.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id}),
    );
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Failed to delete library: ${res.statusCode}');
    }
  }

  // Trigger a rescan for an existing library
  Future<void> scanLibrary(String libraryId) async {
    // First get the library to get its path and type
    final libraries = await fetchLibraries();
    final library = libraries.firstWhere((lib) => lib.id == libraryId);

    final uri = Uri.parse('$baseUrl/scan/path');
    final mediaType = library.type == 'MOVIE' ? 'movie' : 'tv';

    final res = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'path': library.path,
        'options': {
          'libraryName': library.name,
          'mediaType': mediaType,
          'rescan': true, // Force rescan
        },
      }),
    );
    if (res.statusCode != 200 && res.statusCode != 202) {
      throw Exception('Failed to start scan: ${res.statusCode} - ${res.body}');
    }
  }

  // Fetch app settings
  Future<AppSettings> fetchSettings() async {
    final uri = Uri.parse('$baseUrl/settings');
    final res = await client.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Failed to load settings: ${res.statusCode}');
    }
    final json = jsonDecode(res.body);
    return AppSettings.fromJson(json['settings'] ?? {});
  }

  // Update app settings
  Future<AppSettings> updateSettings({
    String? tmdbApiKey,
    int? port,
    bool? enableRouteGuards,
  }) async {
    final uri = Uri.parse('$baseUrl/settings');
    final body = <String, dynamic>{};
    if (tmdbApiKey != null) body['tmdbApiKey'] = tmdbApiKey;
    if (port != null) body['port'] = port;
    if (enableRouteGuards != null) {
      body['enableRouteGuards'] = enableRouteGuards;
    }

    final res = await client.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (res.statusCode != 200) {
      throw Exception(
        'Failed to update settings: ${res.statusCode} - ${res.body}',
      );
    }
    final json = jsonDecode(res.body);
    return AppSettings.fromJson(json['settings'] ?? {});
  }
}
