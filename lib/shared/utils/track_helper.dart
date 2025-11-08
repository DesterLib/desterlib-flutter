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

    // Get readable language name
    String? languageName;
    if (language.isNotEmpty &&
        language.toLowerCase() != 'und' &&
        language.toLowerCase() != 'unknown' &&
        language.toLowerCase() != 'null') {
      languageName = LanguageMapper.getLanguageName(language);
    }

    // Build label with language and title/description
    if (languageName != null && title.isNotEmpty) {
      // Show both language and detailed info
      return '$languageName - $title';
    } else if (languageName != null) {
      // Just language
      return languageName;
    } else if (title.isNotEmpty && !RegExp(r'^[\d\s]+$').hasMatch(title)) {
      // Just title/description
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

    // Get base label with full details
    String baseLabel = getTrackLabel(track);

    // If the track already has detailed title info, no need to number
    if (title.isNotEmpty && !RegExp(r'^[\d\s]+$').hasMatch(title)) {
      return baseLabel;
    }

    // Only add numbering if tracks have same language but no title details
    final sameLangTracks = allTracks.where((t) {
      if (t == null || !isValidTrack(t)) return false;
      final tLang = t.language ?? '';
      final tTitle = t.title ?? '';

      // Only consider tracks with same language and no detailed title
      if (language.isNotEmpty && tLang.isNotEmpty) {
        final hasDetailedTitle =
            tTitle.isNotEmpty && !RegExp(r'^[\d\s]+$').hasMatch(tTitle);
        return tLang == language && !hasDetailedTitle;
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
