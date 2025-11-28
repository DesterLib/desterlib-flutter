// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';

// Features
import 'package:dester/features/settings/presentation/screens/s_settings.dart';

/// Floating action button for adding a library
class AddLibraryFAB extends ConsumerWidget {
  final VoidCallback onPressed;

  const AddLibraryFAB({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return settingsAsync.when(
      data: (settings) {
        // Check if metadata provider is configured (currently TMDB)
        if (!settings.hasMetadataProvider) {
          return FloatingActionButton.extended(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalization.settingsTmdbApiKeyRequiredForLibrary.tr(),
                  ),
                  backgroundColor: Colors.orange,
                  action: SnackBarAction(
                    label: 'Settings',
                    textColor: Colors.white,
                    onPressed: () {
                      context.pushNamed('settings');
                    },
                  ),
                  duration: AppConstants.duration5s,
                ),
              );
            },
            icon: const Icon(LucideIcons.plus300, color: Colors.white70),
            label: Text(
              AppLocalization.settingsLibrariesAddLibrary.tr(),
              style: AppTypography.buttonMedium(color: Colors.white70),
            ),
            backgroundColor: Colors.grey,
            tooltip: AppLocalization.settingsTmdbApiKeyRequiredForLibrary.tr(),
          );
        }

        return FloatingActionButton.extended(
          onPressed: onPressed,
          icon: const Icon(LucideIcons.plus300),
          label: Text(AppLocalization.settingsLibrariesAddLibrary.tr()),
        );
      },
      loading: () => FloatingActionButton.extended(
        onPressed: null,
        icon: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        ),
        label: Text(AppLocalization.settingsLibrariesAddLibrary.tr()),
      ),
      error: (error, stack) => FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading settings: ${error.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        },
        icon: const Icon(Icons.error_outline),
        label: Text(AppLocalization.settingsLibrariesAddLibrary.tr()),
        backgroundColor: Colors.red,
      ),
    );
  }
}
