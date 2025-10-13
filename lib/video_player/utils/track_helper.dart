import 'language_mapper.dart';

/// Utility class for handling audio and subtitle tracks
class TrackHelper {
  /// Check if track is valid (not auto/no and has meaningful info)
  static bool isValidTrack(dynamic track) {
    if (track == null) return false;

    final id = track.id ?? '';
    final title = track.title ?? '';
    final language = track.language ?? '';

    // Filter out auto and no tracks (handled separately)
    if (id == 'auto' || id == 'no') return false;

    // Filter out undefined/unknown languages
    if (language.isEmpty ||
        language.toLowerCase() == 'und' ||
        language.toLowerCase() == 'unknown' ||
        language.toLowerCase() == 'null') {
      // Check if title has meaningful content
      if (title.isEmpty || RegExp(r'^[\d\s]+$').hasMatch(title)) {
        return false;
      }
    }

    // Track must have at least language or a meaningful title
    if (language.isNotEmpty &&
        language.toLowerCase() != 'und' &&
        language.toLowerCase() != 'unknown' &&
        language.toLowerCase() != 'null') {
      return true;
    }

    if (title.isNotEmpty && !RegExp(r'^[\d\s]+$').hasMatch(title)) {
      return true;
    }

    return false;
  }

  /// Get readable label for track
  static String getTrackLabel(dynamic track) {
    if (track == null) return 'None';

    final title = track.title ?? '';
    final language = track.language ?? '';

    // Priority 1: Use language field and convert to readable name
    if (language.isNotEmpty) {
      return LanguageMapper.getLanguageName(language);
    }

    // Priority 2: Check if title is a language code and convert it
    if (title.isNotEmpty && !RegExp(r'^[\d\s]+$').hasMatch(title)) {
      // If title is a short code (likely a language code), convert it
      if (title.length <= 3) {
        return LanguageMapper.getLanguageName(title);
      }
      // If title seems like a description, use it
      return title;
    }

    return 'Unknown';
  }

  /// Get readable label for track with duplicate numbering
  static String getTrackLabelWithContext(
    dynamic track,
    List<dynamic> allTracks,
  ) {
    if (track == null) return 'None';

    final language = track.language ?? '';
    final title = track.title ?? '';
    final id = track.id ?? '';

    // Get base language name
    String baseLabel = getTrackLabel(track);

    // Find all tracks with the same language (valid tracks only)
    final sameLangTracks = allTracks.where((t) {
      if (t == null || !isValidTrack(t)) return false;
      final tLang = t.language ?? '';
      final tTitle = t.title ?? '';

      // Compare by language if available
      if (language.isNotEmpty && tLang.isNotEmpty) {
        return tLang == language;
      }
      // Otherwise compare by title
      if (title.isNotEmpty && tTitle.isNotEmpty) {
        return tTitle == title;
      }
      return false;
    }).toList();

    // If there are multiple tracks with the same language, number them
    if (sameLangTracks.length > 1) {
      // Find this track's position in the list (1-indexed)
      final index = sameLangTracks.indexWhere((t) => t.id == id);
      if (index >= 0) {
        return '$baseLabel ${index + 1}';
      }
    }

    return baseLabel;
  }
}
