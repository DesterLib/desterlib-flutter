import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dester/shared/providers/drawer_provider.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/features/settings/data/tmdb_settings_provider.dart';

/// Bottom sheet widget that listens to drawer state and shows content
class DrawerContent extends ConsumerStatefulWidget {
  const DrawerContent({super.key});

  @override
  ConsumerState<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends ConsumerState<DrawerContent> {
  bool _isBottomSheetOpen = false;
  final TextEditingController _apiKeyController = TextEditingController();

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  void _closeDrawer() {
    if (_isBottomSheetOpen) {
      Navigator.of(context).pop();
      _isBottomSheetOpen = false;
      ref.read(drawerProvider.notifier).closeDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to drawer state changes and show/hide bottom sheet
    ref.listen<DrawerState>(drawerProvider, (previous, next) {
      if (next.isOpen && !_isBottomSheetOpen) {
        _isBottomSheetOpen = true;
        // Small delay to prevent rapid state changes
        Future.delayed(const Duration(milliseconds: 50), () {
          if (mounted && _isBottomSheetOpen) {
            // Show bottom sheet
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: true,
              enableDrag: true,
              backgroundColor: Colors.transparent,
              elevation: 1000,
              useSafeArea: true,
              builder: (context) => _buildBottomSheetContent(context, ref, next),
            ).then((_) {
              // Reset drawer state when bottom sheet is dismissed
              _isBottomSheetOpen = false;
              ref.read(drawerProvider.notifier).closeDrawer();
            });
          }
        });
      }
    });

    return const SizedBox.shrink();
  }

  Widget _buildBottomSheetContent(BuildContext context, WidgetRef ref, DrawerState drawerState) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1a1a1a),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: _buildContent(context, ref, drawerState),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, DrawerState drawerState) {
    switch (drawerState.contentType) {
      case DrawerContentType.tmdbApiKey:
        return _buildTmdbApiKeyContent(context, ref);
      case DrawerContentType.addLibraryItem:
        return _buildAddLibraryItemContent(context, ref);
      case DrawerContentType.updateLibrary:
        return _buildUpdateLibraryContent(context, ref);
      case DrawerContentType.deleteLibraryItem:
        return _buildDeleteLibraryItemContent(context, ref);
      case DrawerContentType.tmdbRequired:
        return _buildTmdbRequiredContent(context, ref);
      case DrawerContentType.none:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTmdbApiKeyContent(BuildContext context, WidgetRef ref) {
    final tmdbNotifier = ref.read(tmdbSettingsProvider.notifier);
    final currentApiKey = ref.read(tmdbSettingsProvider);

    // Update controller text when drawer opens
    if (currentApiKey != null && _apiKeyController.text != currentApiKey) {
      _apiKeyController.text = currentApiKey;
    } else if (currentApiKey == null && _apiKeyController.text.isNotEmpty) {
      _apiKeyController.clear();
    }

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TMDB API Key',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Enter your TMDB API key to enable library management features.',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: -0.5, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          CupertinoTextField(
            controller: _apiKeyController,
            placeholder: 'Enter your TMDB API key',
            obscureText: true,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[600]!),
            ),
            style: const TextStyle(color: Colors.white),
            placeholderStyle: TextStyle(color: Colors.grey[400]),
          ),
          const SizedBox(height: 8),
          const Text(
            'Get your API key from: https://www.themoviedb.org/settings/api',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: -0.5, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DButton(
                label: 'Cancel',
                variant: DButtonVariant.ghost,
                size: DButtonSize.md,
                onTap: _closeDrawer,
              ),
              const SizedBox(width: 12),
              if (currentApiKey != null)
                DButton(
                  label: 'Clear',
                  variant: DButtonVariant.danger,
                  size: DButtonSize.md,
                  onTap: () {
                    tmdbNotifier.clearApiKey();
                    _closeDrawer();
                  },
                ),
              if (currentApiKey != null) const SizedBox(width: 12),
              DButton(
                label: currentApiKey != null ? 'Update' : 'Save',
                variant: DButtonVariant.primary,
                size: DButtonSize.md,
                onTap: () {
                  if (_apiKeyController.text.isNotEmpty) {
                    tmdbNotifier.setApiKey(_apiKeyController.text);
                    _closeDrawer();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddLibraryItemContent(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Library Item',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'This feature will allow you to add movies and TV shows to your library. Implementation coming soon!',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DButton(
                label: 'OK',
                variant: DButtonVariant.primary,
                size: DButtonSize.md,
                onTap: _closeDrawer,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateLibraryContent(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Update Library',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'This will refresh metadata for all items in your library. Implementation coming soon!',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DButton(
                label: 'Cancel',
                variant: DButtonVariant.ghost,
                size: DButtonSize.md,
                onTap: _closeDrawer,
              ),
              const SizedBox(width: 12),
              DButton(
                label: 'Update',
                variant: DButtonVariant.primary,
                size: DButtonSize.md,
                onTap: _closeDrawer,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteLibraryItemContent(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delete Library Item',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'This will open a list of your library items for deletion. Implementation coming soon!',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DButton(
                label: 'Cancel',
                variant: DButtonVariant.ghost,
                size: DButtonSize.md,
                onTap: _closeDrawer,
              ),
              const SizedBox(width: 12),
              DButton(
                label: 'Delete',
                variant: DButtonVariant.danger,
                size: DButtonSize.md,
                onTap: _closeDrawer,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTmdbRequiredContent(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TMDB API Key Required',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'You need to configure your TMDB API key before adding library items. This ensures proper metadata fetching for movies and TV shows.',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DButton(
                label: 'Cancel',
                variant: DButtonVariant.ghost,
                size: DButtonSize.md,
                onTap: _closeDrawer,
              ),
              const SizedBox(width: 12),
              DButton(
                label: 'Configure',
                variant: DButtonVariant.primary,
                size: DButtonSize.md,
                onTap: () {
                  Navigator.of(context).pop(); // Close current bottom sheet
                  ref.read(drawerProvider.notifier).openDrawer(DrawerContentType.tmdbApiKey);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
