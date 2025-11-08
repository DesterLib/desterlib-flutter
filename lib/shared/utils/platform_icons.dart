import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Helper class to provide platform-specific icons.
/// Uses Cupertino icons on iOS/macOS and Material icons on other platforms.
class PlatformIcons {
  static bool get isApplePlatform => Platform.isIOS || Platform.isMacOS;

  // Home icons
  static IconData get home =>
      isApplePlatform ? CupertinoIcons.house_fill : Icons.home;
  static IconData get homeOutlined =>
      isApplePlatform ? CupertinoIcons.house : Icons.home_outlined;

  // Library/Video icons
  static IconData get videoLibrary => isApplePlatform
      ? CupertinoIcons.play_rectangle_fill
      : Icons.video_library;
  static IconData get videoLibraryOutlined => isApplePlatform
      ? CupertinoIcons.play_rectangle
      : Icons.video_library_outlined;

  // Settings icons
  static IconData get settings =>
      isApplePlatform ? CupertinoIcons.settings_solid : Icons.settings;
  static IconData get settingsOutlined =>
      isApplePlatform ? CupertinoIcons.settings : Icons.settings_outlined;

  // Search icon
  static IconData get search =>
      isApplePlatform ? CupertinoIcons.search : Icons.search;

  // Media icons
  static IconData get playArrow =>
      isApplePlatform ? CupertinoIcons.play_fill : Icons.play_arrow_rounded;
  static IconData get pause =>
      isApplePlatform ? CupertinoIcons.pause_fill : Icons.pause_rounded;
  static IconData get replay10 =>
      isApplePlatform ? CupertinoIcons.gobackward_10 : Icons.replay_10_rounded;
  static IconData get forward10 =>
      isApplePlatform ? CupertinoIcons.goforward_10 : Icons.forward_10_rounded;
  static IconData get replay =>
      isApplePlatform ? CupertinoIcons.arrow_clockwise : Icons.replay_rounded;
  static IconData get speed =>
      isApplePlatform ? CupertinoIcons.speedometer : Icons.speed_rounded;
  static IconData get subtitles =>
      isApplePlatform ? CupertinoIcons.textbox : Icons.subtitles_rounded;
  static IconData get movie =>
      isApplePlatform ? CupertinoIcons.film : Icons.movie_outlined;
  static IconData get add =>
      isApplePlatform ? CupertinoIcons.add : Icons.add_circle_rounded;
  static IconData get star =>
      isApplePlatform ? CupertinoIcons.star_fill : Icons.star_rounded;
  static IconData get time =>
      isApplePlatform ? CupertinoIcons.time : Icons.access_time_rounded;
  static IconData get calendar => isApplePlatform
      ? CupertinoIcons.calendar_today
      : Icons.calendar_today_rounded;
  static IconData get brokenImage =>
      isApplePlatform ? CupertinoIcons.photo_fill : Icons.broken_image_rounded;

  // Navigation icons
  static IconData get arrowBack =>
      isApplePlatform ? CupertinoIcons.back : Icons.arrow_back_ios_new_rounded;
  static IconData get arrowForward => isApplePlatform
      ? CupertinoIcons.arrow_right
      : Icons.arrow_forward_rounded;
  static IconData get close =>
      isApplePlatform ? CupertinoIcons.xmark : Icons.close_rounded;

  // Settings-specific icons
  static IconData get palette =>
      isApplePlatform ? CupertinoIcons.paintbrush : Icons.palette_outlined;
  static IconData get language =>
      isApplePlatform ? CupertinoIcons.globe : Icons.language_outlined;
  static IconData get notifications =>
      isApplePlatform ? CupertinoIcons.bell : Icons.notifications_outlined;
  static IconData get videoSettings => isApplePlatform
      ? CupertinoIcons.video_camera
      : Icons.video_settings_outlined;
  static IconData get folder =>
      isApplePlatform ? CupertinoIcons.folder : Icons.folder_outlined;
  static IconData get playCircle =>
      isApplePlatform ? CupertinoIcons.play_circle : Icons.play_circle_outline;
  static IconData get person =>
      isApplePlatform ? CupertinoIcons.person : Icons.person_outline;
  static IconData get starOutlined =>
      isApplePlatform ? CupertinoIcons.star : Icons.star_outline;
  static IconData get logout =>
      isApplePlatform ? CupertinoIcons.square_arrow_right : Icons.logout;
  static IconData get code =>
      isApplePlatform ? CupertinoIcons.doc_text : Icons.code_outlined;
  static IconData get cleaning =>
      isApplePlatform ? CupertinoIcons.trash : Icons.cleaning_services_outlined;
  static IconData get restore =>
      isApplePlatform ? CupertinoIcons.refresh : Icons.restore_outlined;
  static IconData get chevronLeft =>
      isApplePlatform ? CupertinoIcons.chevron_left : Icons.chevron_left;
  static IconData get chevronRight =>
      isApplePlatform ? CupertinoIcons.chevron_right : Icons.chevron_right;

  // Library Management icons
  static IconData get key =>
      isApplePlatform ? CupertinoIcons.lock : Icons.vpn_key_outlined;
  static IconData get refresh =>
      isApplePlatform ? CupertinoIcons.refresh : Icons.refresh_outlined;
  static IconData get delete =>
      isApplePlatform ? CupertinoIcons.delete : Icons.delete_outline;

  // Status icons
  static IconData get checkCircle => isApplePlatform
      ? CupertinoIcons.checkmark_circle_fill
      : Icons.check_circle;
  static IconData get errorCircle =>
      isApplePlatform ? CupertinoIcons.xmark_circle_fill : Icons.error;
  static IconData get loading =>
      isApplePlatform ? CupertinoIcons.arrow_clockwise : Icons.refresh;
  static IconData get info =>
      isApplePlatform ? CupertinoIcons.info_circle : Icons.info_outline;
  static IconData get warning => isApplePlatform
      ? CupertinoIcons.exclamationmark_triangle_fill
      : Icons.warning;

  // Other icons
  static IconData get moreHoriz =>
      isApplePlatform ? CupertinoIcons.ellipsis : Icons.more_horiz_rounded;
  static IconData get libraryBooks =>
      isApplePlatform ? CupertinoIcons.book : Icons.library_books;
}
