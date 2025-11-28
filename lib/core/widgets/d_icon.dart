// External packages
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Icon names enum for type-safe icon selection
enum DIconName {
  play,
  pause,
  stop,
  skipForward,
  skipBack,
  volume,
  volumeMute,
  settings,
  home,
  search,
  plus,
  minus,
  edit,
  delete,
  trash,
  check,
  close,
  arrowLeft,
  arrowRight,
  arrowUp,
  arrowDown,
  heart,
  ellipsis,
  cloud,
  cloudOff,
  film,
  tv,
  music,
  bookOpen,
  library,
  inbox,
  error,
  chevronLeft,
  chevronRight,
  refreshCw,
  link2,
  link2Off,
  server,
  key,
  tag,
  cloudCheck,
  database,
  scan,
  folderCog,
}

/// Stroke width mapping to Lucide icon suffixes (100-600)
class DIconStrokeWidth {
  /// Get the Lucide icon suffix for a given stroke width (decimal value)
  /// Maps relative decimal values to Lucide suffixes (100-600)
  static String getSuffix(double strokeWidth) {
    // Map decimal stroke width values to Lucide suffixes
    // Common mappings: 1.0 -> 100, 1.5 -> 200, 2.0 -> 300, etc.
    if (strokeWidth <= 0.5) return '100';
    if (strokeWidth <= 1.0) return '100';
    if (strokeWidth <= 1.5) return '200';
    if (strokeWidth <= 2.0) return '300';
    if (strokeWidth <= 2.5) return '400';
    if (strokeWidth <= 3.0) return '500';
    return '600';
  }
}

/// Helper function to convert DIconName to IconData
/// Useful for widgets that require IconData instead of DIcon widget
IconData getIconDataFromDIconName(
  DIconName iconName, {
  double strokeWidth = 2.0,
}) {
  final suffix = DIconStrokeWidth.getSuffix(strokeWidth);
  return LucideIconMap.getIcon(iconName, suffix);
}

/// Custom SVG icons (filled versions)
class CustomIcons {
  static const String play = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M5.00002 5.00004C4.99991 4.64814 5.09266 4.30243 5.2689 3.99783C5.44514 3.69324 5.69862 3.44053 6.00377 3.26524C6.30891 3.08995 6.6549 2.99827 7.0068 2.99946C7.35871 3.00066 7.70407 3.09468 8.00802 3.27204L20.005 10.27C20.3078 10.4457 20.5591 10.6978 20.734 11.001C20.9088 11.3043 21.0009 11.6481 21.0012 11.9982C21.0016 12.3482 20.91 12.6922 20.7357 12.9958C20.5614 13.2993 20.3105 13.5518 20.008 13.728L8.00802 20.728C7.70407 20.9054 7.35871 20.9994 7.0068 21.0006C6.6549 21.0018 6.30891 20.9101 6.00377 20.7348C5.69862 20.5596 5.44514 20.3069 5.2689 20.0023C5.09266 19.6977 4.99991 19.352 5.00002 19V5.00004Z" fill="currentColor" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  static const String home = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M15 21V13C15 12.7348 14.8946 12.4804 14.7071 12.2929C14.5196 12.1054 14.2652 12 14 12H10C9.73478 12 9.48043 12.1054 9.29289 12.2929C9.10536 12.4804 9 12.7348 9 13V21" fill="currentColor"/>
<path d="M15 21V13C15 12.7348 14.8946 12.4804 14.7071 12.2929C14.5196 12.1054 14.2652 12 14 12H10C9.73478 12 9.48043 12.1054 9.29289 12.2929C9.10536 12.4804 9 12.7348 9 13V21" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M3 10C2.99993 9.70907 3.06333 9.42162 3.18579 9.15772C3.30824 8.89381 3.4868 8.6598 3.709 8.472L10.709 2.472C11.07 2.16691 11.5274 1.99952 12 1.99952C12.4726 1.99952 12.93 2.16691 13.291 2.472L20.291 8.472C20.5132 8.6598 20.6918 8.89381 20.8142 9.15772C20.9367 9.42162 21.0001 9.70907 21 10V19C21 19.5304 20.7893 20.0391 20.4142 20.4142C20.0391 20.7893 19.5304 21 19 21H5C4.46957 21 3.96086 20.7893 3.58579 20.4142C3.21071 20.0391 3 19.5304 3 19V10Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';
}

/// Maps icon names to Lucide icon data with stroke width suffixes
class LucideIconMap {
  static IconData getIcon(DIconName name, String suffix) {
    switch (name) {
      case DIconName.play:
        return _getLucideIconWithSuffix('play', suffix);
      case DIconName.pause:
        return _getLucideIconWithSuffix('pause', suffix);
      case DIconName.stop:
        return _getLucideIconWithSuffix('square', suffix);
      case DIconName.skipForward:
        return _getLucideIconWithSuffix('skipForward', suffix);
      case DIconName.skipBack:
        return _getLucideIconWithSuffix('skipBack', suffix);
      case DIconName.volume:
        return _getLucideIconWithSuffix('volume2', suffix);
      case DIconName.volumeMute:
        return _getLucideIconWithSuffix('volumeX', suffix);
      case DIconName.settings:
        return _getLucideIconWithSuffix('settings', suffix);
      case DIconName.home:
        return _getLucideIconWithSuffix('house', suffix);
      case DIconName.search:
        return _getLucideIconWithSuffix('search', suffix);
      case DIconName.plus:
        return _getLucideIconWithSuffix('plus', suffix);
      case DIconName.minus:
        return _getLucideIconWithSuffix('minus', suffix);
      case DIconName.edit:
        return _getLucideIconWithSuffix('pencil', suffix);
      case DIconName.delete:
      case DIconName.trash:
        return _getLucideIconWithSuffix('trash2', suffix);
      case DIconName.check:
        return _getLucideIconWithSuffix('check', suffix);
      case DIconName.close:
        return _getLucideIconWithSuffix('x', suffix);
      case DIconName.arrowLeft:
        return _getLucideIconWithSuffix('arrowLeft', suffix);
      case DIconName.arrowRight:
        return _getLucideIconWithSuffix('arrowRight', suffix);
      case DIconName.arrowUp:
        return _getLucideIconWithSuffix('arrowUp', suffix);
      case DIconName.arrowDown:
        return _getLucideIconWithSuffix('arrowDown', suffix);
      case DIconName.heart:
        return _getLucideIconWithSuffix('heart', suffix);
      case DIconName.ellipsis:
        return _getLucideIconWithSuffix('ellipsis', suffix);
      case DIconName.cloud:
        return _getLucideIconWithSuffix('cloud', suffix);
      case DIconName.cloudOff:
        return _getLucideIconWithSuffix('cloudOff', suffix);
      case DIconName.film:
        return _getLucideIconWithSuffix('film', suffix);
      case DIconName.tv:
        return _getLucideIconWithSuffix('tv', suffix);
      case DIconName.music:
        return _getLucideIconWithSuffix('music', suffix);
      case DIconName.bookOpen:
        return _getLucideIconWithSuffix('bookOpen', suffix);
      case DIconName.library:
        return _getLucideIconWithSuffix('library', suffix);
      case DIconName.inbox:
        return _getLucideIconWithSuffix('inbox', suffix);
      case DIconName.error:
        return _getLucideIconWithSuffix('circleAlert', suffix);
      case DIconName.chevronLeft:
        return _getLucideIconWithSuffix('chevronLeft', suffix);
      case DIconName.chevronRight:
        return _getLucideIconWithSuffix('chevronRight', suffix);
      case DIconName.refreshCw:
        return _getLucideIconWithSuffix('refreshCw', suffix);
      case DIconName.link2:
        return _getLucideIconWithSuffix('link2', suffix);
      case DIconName.link2Off:
        return _getLucideIconWithSuffix('link2Off', suffix);
      case DIconName.server:
        return _getLucideIconWithSuffix('server', suffix);
      case DIconName.key:
        return _getLucideIconWithSuffix('key', suffix);
      case DIconName.tag:
        return _getLucideIconWithSuffix('tag', suffix);
      case DIconName.cloudCheck:
        return _getLucideIconWithSuffix('cloudCheck', suffix);
      case DIconName.database:
        return _getLucideIconWithSuffix('database', suffix);
      case DIconName.scan:
        return _getLucideIconWithSuffix('scan', suffix);
      case DIconName.folderCog:
        return _getLucideIconWithSuffix('folderCog', suffix);
    }
  }

  static IconData _getLucideIconWithSuffix(String baseName, String suffix) {
    // Try to get the icon with the specific suffix, fallback to base icon
    final iconName = '$baseName$suffix';

    // Map common suffixes (100-600) to available Lucide icons
    // Note: Not all icons have all suffixes, so we fallback to base or closest available
    switch (iconName) {
      // Suffix 100
      case 'play100':
        return LucideIcons.play100;
      case 'pause100':
        return LucideIcons.pause100;
      case 'square100':
        return LucideIcons.square100;
      case 'skipForward100':
        return LucideIcons.skipForward100;
      case 'skipBack100':
        return LucideIcons.skipBack100;
      case 'volume2100':
        return LucideIcons.volume2100;
      case 'volumeX100':
        return LucideIcons.volumeX100;
      case 'settings100':
        return LucideIcons.settings100;
      case 'house100':
        return LucideIcons.house100;
      case 'search100':
        return LucideIcons.search100;
      case 'plus100':
        return LucideIcons.plus100;
      case 'minus100':
        return LucideIcons.minus100;
      case 'pencil100':
        return LucideIcons.pencil100;
      case 'trash2100':
        return LucideIcons.trash2100;
      case 'check100':
        return LucideIcons.check100;
      case 'x100':
        return LucideIcons.x100;
      case 'arrowLeft100':
        return LucideIcons.arrowLeft100;
      case 'arrowRight100':
        return LucideIcons.arrowRight100;
      case 'arrowUp100':
        return LucideIcons.arrowUp100;
      case 'arrowDown100':
        return LucideIcons.arrowDown100;

      // Suffix 200
      case 'play200':
        return LucideIcons.play200;
      case 'pause200':
        return LucideIcons.pause200;
      case 'square200':
        return LucideIcons.square200;
      case 'skipForward200':
        return LucideIcons.skipForward200;
      case 'skipBack200':
        return LucideIcons.skipBack200;
      case 'volume2200':
        return LucideIcons.volume2200;
      case 'volumeX200':
        return LucideIcons.volumeX200;
      case 'settings200':
        return LucideIcons.settings200;
      case 'house200':
        return LucideIcons.house200;
      case 'search200':
        return LucideIcons.search200;
      case 'plus200':
        return LucideIcons.plus200;
      case 'minus200':
        return LucideIcons.minus200;
      case 'pencil200':
        return LucideIcons.pencil200;
      case 'trash2200':
        return LucideIcons.trash2200;
      case 'check200':
        return LucideIcons.check200;
      case 'x200':
        return LucideIcons.x200;
      case 'arrowLeft200':
        return LucideIcons.arrowLeft200;
      case 'arrowRight200':
        return LucideIcons.arrowRight200;
      case 'arrowUp200':
        return LucideIcons.arrowUp200;
      case 'arrowDown200':
        return LucideIcons.arrowDown200;

      // Suffix 300 (most common)
      case 'play300':
        return LucideIcons.play300;
      case 'pause300':
        return LucideIcons.pause300;
      case 'square300':
        return LucideIcons.square300;
      case 'skipForward300':
        return LucideIcons.skipForward300;
      case 'skipBack300':
        return LucideIcons.skipBack300;
      case 'volume2300':
        return LucideIcons.volume2300;
      case 'volumeX300':
        return LucideIcons.volumeX300;
      case 'settings300':
        return LucideIcons.settings300;
      case 'house300':
        return LucideIcons.house300;
      case 'search300':
        return LucideIcons.search300;
      case 'plus300':
        return LucideIcons.plus300;
      case 'minus300':
        return LucideIcons.minus300;
      case 'pencil300':
        return LucideIcons.pencil300;
      case 'trash2300':
        return LucideIcons.trash2300;
      case 'check300':
        return LucideIcons.check300;
      case 'x300':
        return LucideIcons.x300;
      case 'arrowLeft300':
        return LucideIcons.arrowLeft300;
      case 'arrowRight300':
        return LucideIcons.arrowRight300;
      case 'arrowUp300':
        return LucideIcons.arrowUp300;
      case 'arrowDown300':
        return LucideIcons.arrowDown300;

      // Suffix 400
      case 'play400':
        return LucideIcons.play400;
      case 'pause400':
        return LucideIcons.pause400;
      case 'square400':
        return LucideIcons.square400;
      case 'skipForward400':
        return LucideIcons.skipForward400;
      case 'skipBack400':
        return LucideIcons.skipBack400;
      case 'volume2400':
        return LucideIcons.volume2400;
      case 'volumeX400':
        return LucideIcons.volumeX400;
      case 'settings400':
        return LucideIcons.settings400;
      case 'house400':
        return LucideIcons.house400;
      case 'search400':
        return LucideIcons.search400;
      case 'plus400':
        return LucideIcons.plus400;
      case 'minus400':
        return LucideIcons.minus400;
      case 'pencil400':
        return LucideIcons.pencil400;
      case 'trash2400':
        return LucideIcons.trash2400;
      case 'check400':
        return LucideIcons.check400;
      case 'x400':
        return LucideIcons.x400;
      case 'arrowLeft400':
        return LucideIcons.arrowLeft400;
      case 'arrowRight400':
        return LucideIcons.arrowRight400;
      case 'arrowUp400':
        return LucideIcons.arrowUp400;
      case 'arrowDown400':
        return LucideIcons.arrowDown400;

      // Suffix 500
      case 'play500':
        return LucideIcons.play500;
      case 'pause500':
        return LucideIcons.pause500;
      case 'square500':
        return LucideIcons.square500;
      case 'skipForward500':
        return LucideIcons.skipForward500;
      case 'skipBack500':
        return LucideIcons.skipBack500;
      case 'volume2500':
        return LucideIcons.volume2500;
      case 'volumeX500':
        return LucideIcons.volumeX500;
      case 'settings500':
        return LucideIcons.settings500;
      case 'house500':
        return LucideIcons.house500;
      case 'search500':
        return LucideIcons.search500;
      case 'plus500':
        return LucideIcons.plus500;
      case 'minus500':
        return LucideIcons.minus500;
      case 'pencil500':
        return LucideIcons.pencil500;
      case 'trash2500':
        return LucideIcons.trash2500;
      case 'check500':
        return LucideIcons.check500;
      case 'x500':
        return LucideIcons.x500;
      case 'arrowLeft500':
        return LucideIcons.arrowLeft500;
      case 'arrowRight500':
        return LucideIcons.arrowRight500;
      case 'arrowUp500':
        return LucideIcons.arrowUp500;
      case 'arrowDown500':
        return LucideIcons.arrowDown500;

      // Suffix 600
      case 'play600':
        return LucideIcons.play600;
      case 'pause600':
        return LucideIcons.pause600;
      case 'square600':
        return LucideIcons.square600;
      case 'skipForward600':
        return LucideIcons.skipForward600;
      case 'skipBack600':
        return LucideIcons.skipBack600;
      case 'volume2600':
        return LucideIcons.volume2600;
      case 'volumeX600':
        return LucideIcons.volumeX600;
      case 'settings600':
        return LucideIcons.settings600;
      case 'house600':
        return LucideIcons.house600;
      case 'search600':
        return LucideIcons.search600;
      case 'plus600':
        return LucideIcons.plus600;
      case 'minus600':
        return LucideIcons.minus600;
      case 'pencil600':
        return LucideIcons.pencil600;
      case 'trash2600':
        return LucideIcons.trash2600;
      case 'check600':
        return LucideIcons.check600;
      case 'x600':
        return LucideIcons.x600;
      case 'arrowLeft600':
        return LucideIcons.arrowLeft600;
      case 'arrowRight600':
        return LucideIcons.arrowRight600;
      case 'arrowUp600':
        return LucideIcons.arrowUp600;
      case 'arrowDown600':
        return LucideIcons.arrowDown600;

      // Missing icons with suffix variants
      case 'heart100':
        return LucideIcons.heart100;
      case 'heart200':
        return LucideIcons.heart200;
      case 'heart300':
        return LucideIcons.heart300;
      case 'heart400':
        return LucideIcons.heart400;
      case 'heart500':
        return LucideIcons.heart500;
      case 'heart600':
        return LucideIcons.heart600;
      case 'ellipsis100':
        return LucideIcons.ellipsis100;
      case 'ellipsis200':
        return LucideIcons.ellipsis200;
      case 'ellipsis300':
        return LucideIcons.ellipsis300;
      case 'ellipsis400':
        return LucideIcons.ellipsis400;
      case 'ellipsis500':
        return LucideIcons.ellipsis500;
      case 'ellipsis600':
        return LucideIcons.ellipsis600;
      case 'cloud100':
        return LucideIcons.cloud100;
      case 'cloud200':
        return LucideIcons.cloud200;
      case 'cloud300':
        return LucideIcons.cloud300;
      case 'cloud400':
        return LucideIcons.cloud400;
      case 'cloud500':
        return LucideIcons.cloud500;
      case 'cloud600':
        return LucideIcons.cloud600;
      case 'cloudOff100':
        return LucideIcons.cloudOff100;
      case 'cloudOff200':
        return LucideIcons.cloudOff200;
      case 'cloudOff300':
        return LucideIcons.cloudOff300;
      case 'cloudOff400':
        return LucideIcons.cloudOff400;
      case 'cloudOff500':
        return LucideIcons.cloudOff500;
      case 'cloudOff600':
        return LucideIcons.cloudOff600;
      case 'film100':
        return LucideIcons.film100;
      case 'film200':
        return LucideIcons.film200;
      case 'film300':
        return LucideIcons.film300;
      case 'film400':
        return LucideIcons.film400;
      case 'film500':
        return LucideIcons.film500;
      case 'film600':
        return LucideIcons.film600;
      case 'tv100':
        return LucideIcons.tv100;
      case 'tv200':
        return LucideIcons.tv200;
      case 'tv300':
        return LucideIcons.tv300;
      case 'tv400':
        return LucideIcons.tv400;
      case 'tv500':
        return LucideIcons.tv500;
      case 'tv600':
        return LucideIcons.tv600;
      case 'music100':
        return LucideIcons.music100;
      case 'music200':
        return LucideIcons.music200;
      case 'music300':
        return LucideIcons.music300;
      case 'music400':
        return LucideIcons.music400;
      case 'music500':
        return LucideIcons.music500;
      case 'music600':
        return LucideIcons.music600;
      case 'bookOpen100':
        return LucideIcons.bookOpen100;
      case 'bookOpen200':
        return LucideIcons.bookOpen200;
      case 'bookOpen300':
        return LucideIcons.bookOpen300;
      case 'bookOpen400':
        return LucideIcons.bookOpen400;
      case 'bookOpen500':
        return LucideIcons.bookOpen500;
      case 'bookOpen600':
        return LucideIcons.bookOpen600;
      case 'library100':
        return LucideIcons.library100;
      case 'library200':
        return LucideIcons.library200;
      case 'library300':
        return LucideIcons.library300;
      case 'library400':
        return LucideIcons.library400;
      case 'library500':
        return LucideIcons.library500;
      case 'library600':
        return LucideIcons.library600;
      case 'inbox100':
        return LucideIcons.inbox100;
      case 'inbox200':
        return LucideIcons.inbox200;
      case 'inbox300':
        return LucideIcons.inbox300;
      case 'inbox400':
        return LucideIcons.inbox400;
      case 'inbox500':
        return LucideIcons.inbox500;
      case 'inbox600':
        return LucideIcons.inbox600;
      case 'circleAlert100':
        return LucideIcons.circleAlert100;
      case 'circleAlert200':
        return LucideIcons.circleAlert200;
      case 'circleAlert300':
        return LucideIcons.circleAlert300;
      case 'circleAlert400':
        return LucideIcons.circleAlert400;
      case 'circleAlert500':
        return LucideIcons.circleAlert500;
      case 'circleAlert600':
        return LucideIcons.circleAlert600;
      case 'chevronLeft100':
        return LucideIcons.chevronLeft100;
      case 'chevronLeft200':
        return LucideIcons.chevronLeft200;
      case 'chevronLeft300':
        return LucideIcons.chevronLeft300;
      case 'chevronLeft400':
        return LucideIcons.chevronLeft400;
      case 'chevronLeft500':
        return LucideIcons.chevronLeft500;
      case 'chevronLeft600':
        return LucideIcons.chevronLeft600;
      case 'chevronRight100':
        return LucideIcons.chevronRight100;
      case 'chevronRight200':
        return LucideIcons.chevronRight200;
      case 'chevronRight300':
        return LucideIcons.chevronRight300;
      case 'chevronRight400':
        return LucideIcons.chevronRight400;
      case 'chevronRight500':
        return LucideIcons.chevronRight500;
      case 'chevronRight600':
        return LucideIcons.chevronRight600;
      case 'refreshCw100':
        return LucideIcons.refreshCw100;
      case 'refreshCw200':
        return LucideIcons.refreshCw200;
      case 'refreshCw300':
        return LucideIcons.refreshCw300;
      case 'refreshCw400':
        return LucideIcons.refreshCw400;
      case 'refreshCw500':
        return LucideIcons.refreshCw500;
      case 'refreshCw600':
        return LucideIcons.refreshCw600;

      // Link2 icons
      case 'link2100':
        return LucideIcons.link2100;
      case 'link2200':
        return LucideIcons.link2200;
      case 'link2300':
        return LucideIcons.link2300;
      case 'link2400':
        return LucideIcons.link2400;
      case 'link2500':
        return LucideIcons.link2500;
      case 'link2600':
        return LucideIcons.link2600;

      // Link2Off icons
      case 'link2Off100':
        return LucideIcons.link2Off100;
      case 'link2Off200':
        return LucideIcons.link2Off200;
      case 'link2Off300':
        return LucideIcons.link2Off300;
      case 'link2Off400':
        return LucideIcons.link2Off400;
      case 'link2Off500':
        return LucideIcons.link2Off500;
      case 'link2Off600':
        return LucideIcons.link2Off600;

      // Server icons
      case 'server100':
        return LucideIcons.server100;
      case 'server200':
        return LucideIcons.server200;
      case 'server300':
        return LucideIcons.server300;
      case 'server400':
        return LucideIcons.server400;
      case 'server500':
        return LucideIcons.server500;
      case 'server600':
        return LucideIcons.server600;

      // Database icons
      case 'database100':
        return LucideIcons.database100;
      case 'database200':
        return LucideIcons.database200;
      case 'database300':
        return LucideIcons.database300;
      case 'database400':
        return LucideIcons.database400;
      case 'database500':
        return LucideIcons.database500;
      case 'database600':
        return LucideIcons.database600;

      // Key icons
      case 'key100':
        return LucideIcons.key100;
      case 'key200':
        return LucideIcons.key200;
      case 'key300':
        return LucideIcons.key300;
      case 'key400':
        return LucideIcons.key400;
      case 'key500':
        return LucideIcons.key500;
      case 'key600':
        return LucideIcons.key600;

      // Tag icons
      case 'tag100':
        return LucideIcons.tag100;
      case 'tag200':
        return LucideIcons.tag200;
      case 'tag300':
        return LucideIcons.tag300;
      case 'tag400':
        return LucideIcons.tag400;
      case 'tag500':
        return LucideIcons.tag500;
      case 'tag600':
        return LucideIcons.tag600;

      // CloudCheck icons
      case 'cloudCheck100':
        return LucideIcons.cloudCheck100;
      case 'cloudCheck200':
        return LucideIcons.cloudCheck200;
      case 'cloudCheck300':
        return LucideIcons.cloudCheck300;
      case 'cloudCheck400':
        return LucideIcons.cloudCheck400;
      case 'cloudCheck500':
        return LucideIcons.cloudCheck500;
      case 'cloudCheck600':
        return LucideIcons.cloudCheck600;

      // FolderCog icons
      case 'folderCog100':
        return LucideIcons.folderCog100;
      case 'folderCog200':
        return LucideIcons.folderCog200;
      case 'folderCog300':
        return LucideIcons.folderCog300;
      case 'folderCog400':
        return LucideIcons.folderCog400;
      case 'folderCog500':
        return LucideIcons.folderCog500;
      case 'folderCog600':
        return LucideIcons.folderCog600;

      // Fallback to default icon
      default:
        return LucideIcons.circle;
    }
  }
}

/// A customizable icon widget that supports both Lucide icons and custom SVG icons
class DIcon extends StatelessWidget {
  /// The icon name to display
  final DIconName icon;

  /// Icon size in pixels (width and height)
  /// Defaults to 24px
  final double size;

  /// Stroke width as decimal value (maps to Lucide suffixes 100-600)
  /// Examples: 1.0 -> 100, 1.5 -> 200, 2.0 -> 300, 2.5 -> 400, 3.0 -> 500, 3.5+ -> 600
  /// Defaults to 2.0 (maps to suffix 300)
  final double strokeWidth;

  /// Icon color
  final Color? color;

  /// Whether to use filled custom SVG icons instead of Lucide icons
  /// When true, uses custom SVG icons (size and strokeWidth are ignored for these)
  final bool filled;

  const DIcon({
    super.key,
    required this.icon,
    this.size = 24.0,
    this.strokeWidth = 2.0,
    this.color,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor =
        color ?? Theme.of(context).iconTheme.color ?? Colors.white;

    if (filled) {
      // Use custom SVG icons (fixed size, ignore size parameter)
      return _buildCustomSvgIcon(iconColor);
    } else {
      // Use Lucide icons with size suffix
      return _buildLucideIcon(iconColor);
    }
  }

  Widget _buildCustomSvgIcon(Color iconColor) {
    final svgString = _getCustomSvgString(icon);
    if (svgString == null) {
      // Fallback to Lucide icon if custom SVG not available
      return _buildLucideIcon(iconColor);
    }

    return SvgPicture.string(
      svgString,
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      width: size,
      height: size,
    );
  }

  Widget _buildLucideIcon(Color iconColor) {
    final suffix = DIconStrokeWidth.getSuffix(strokeWidth);
    final iconData = LucideIconMap.getIcon(icon, suffix);

    return Icon(iconData, size: size, color: iconColor);
  }

  String? _getCustomSvgString(DIconName name) {
    switch (name) {
      case DIconName.play:
        return CustomIcons.play;
      case DIconName.home:
        return CustomIcons.home;
      // Add more custom SVG icons here as they are created
      default:
        return null;
    }
  }
}
