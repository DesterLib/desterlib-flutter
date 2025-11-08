#!/usr/bin/env dart

import 'dart:io';

/// Simple version bump script for pubspec.yaml
/// Usage:
///   dart run scripts/version_bump.dart [major|minor|patch]
///
/// If no argument is provided, it will bump the build number only.
///
/// Examples:
///   dart run scripts/version_bump.dart patch  # 0.1.0+1 -> 0.1.1+1
///   dart run scripts/version_bump.dart minor  # 0.1.0+1 -> 0.2.0+1
///   dart run scripts/version_bump.dart major  # 0.1.0+1 -> 1.0.0+1
///   dart run scripts/version_bump.dart        # 0.1.0+1 -> 0.1.0+2 (build only)

void main(List<String> arguments) {
  final bumpType = arguments.isEmpty ? 'build' : arguments[0].toLowerCase();

  if (!['major', 'minor', 'patch', 'build'].contains(bumpType)) {
    print('❌ Invalid bump type: $bumpType');
    print(
      'Valid options: major, minor, patch, build (or no argument for build)',
    );
    exit(1);
  }

  final pubspecFile = File('pubspec.yaml');

  if (!pubspecFile.existsSync()) {
    print('❌ pubspec.yaml not found');
    exit(1);
  }

  final content = pubspecFile.readAsStringSync();
  final lines = content.split('\n');

  String? newContent;
  String? oldVersion;
  String? newVersion;

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];

    if (line.startsWith('version:')) {
      final versionMatch = RegExp(
        r'version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)',
      ).firstMatch(line);

      if (versionMatch == null) {
        print('❌ Could not parse version from: $line');
        exit(1);
      }

      final major = int.parse(versionMatch.group(1)!);
      final minor = int.parse(versionMatch.group(2)!);
      final patch = int.parse(versionMatch.group(3)!);
      final build = int.parse(versionMatch.group(4)!);

      oldVersion = '$major.$minor.$patch+$build';

      int newMajor = major;
      int newMinor = minor;
      int newPatch = patch;
      int newBuild = build;

      switch (bumpType) {
        case 'major':
          newMajor++;
          newMinor = 0;
          newPatch = 0;
          newBuild = 1;
          break;
        case 'minor':
          newMinor++;
          newPatch = 0;
          newBuild = 1;
          break;
        case 'patch':
          newPatch++;
          newBuild = 1;
          break;
        case 'build':
          newBuild++;
          break;
      }

      newVersion = '$newMajor.$newMinor.$newPatch+$newBuild';
      lines[i] = 'version: $newVersion';
      break;
    }
  }

  if (oldVersion == null || newVersion == null) {
    print('❌ Could not find version in pubspec.yaml');
    exit(1);
  }

  newContent = lines.join('\n');
  pubspecFile.writeAsStringSync(newContent);

  print('✅ Version bumped: $oldVersion → $newVersion');
  print('');
  print('Next steps:');
  print('  1. Review the changes');
  print('  2. Update CHANGELOG.md');
  print(
    '  3. Commit: git commit -am "chore(release): bump version to $newVersion"',
  );
  print(
    '  4. Tag: git tag -a v${newVersion.split('+')[0]} -m "Release ${newVersion.split('+')[0]}"',
  );
  print('  5. Push: git push origin main --tags');
}
