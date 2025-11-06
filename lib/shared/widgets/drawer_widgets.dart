import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/features/settings/data/tmdb_settings_provider.dart';

class TmdbApiKeyDrawer extends ConsumerStatefulWidget {
  const TmdbApiKeyDrawer({super.key});

  @override
  ConsumerState<TmdbApiKeyDrawer> createState() => _TmdbApiKeyDrawerState();
}

class _TmdbApiKeyDrawerState extends ConsumerState<TmdbApiKeyDrawer> {
  final TextEditingController _apiKeyController = TextEditingController();

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tmdbNotifier = ref.read(tmdbSettingsProvider.notifier);
    final currentApiKeyAsync = ref.watch(tmdbSettingsProvider);

    // Extract the current API key value
    String? currentApiKey;
    currentApiKeyAsync.whenData((data) => currentApiKey = data);

    // Update controller text when drawer opens
    if (currentApiKey != null && _apiKeyController.text != currentApiKey) {
      _apiKeyController.text = currentApiKey!;
    } else if (currentApiKey == null && _apiKeyController.text.isNotEmpty) {
      _apiKeyController.clear();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return GestureDetector(
      onTap: () {
        // Close keyboard if open
        FocusScope.of(context).unfocus();
      },
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 500 : double.infinity,
              maxHeight: isDesktop
                  ? 600
                  : MediaQuery.of(context).size.height * 0.9,
            ),
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1a1a1a),
              borderRadius: BorderRadius.circular(isDesktop ? 16 : 24),
              border: isDesktop ? Border.all(color: Colors.grey[800]!) : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDesktop ? 16 : 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isDesktop) ...[
                    // Handle bar for mobile
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                  Flexible(
                    child: SingleChildScrollView(
                      child: Padding(
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
                            // Header with title and close button
                            Row(
                              children: [
                                const Text(
                                  'TMDB API Key',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                                DButton(
                                  icon: Icons.close,
                                  variant: DButtonVariant.ghost,
                                  size: DButtonSize.sm,
                                  onTap: () => context.pop(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Enter your TMDB API key to enable library management features.',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.5,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 16),
                            CupertinoTextField(
                              controller: _apiKeyController,
                              placeholder: 'Enter your TMDB API key',
                              obscureText: true,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[600]!),
                              ),
                              style: const TextStyle(color: Colors.white),
                              placeholderStyle: TextStyle(
                                color: Colors.grey[400],
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Get your API key from: https://www.themoviedb.org/settings/api',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.5,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (currentApiKey != null)
                                  DButton(
                                    label: 'Clear',
                                    variant: DButtonVariant.danger,
                                    size: DButtonSize.sm,
                                    onTap: () async {
                                      try {
                                        await tmdbNotifier.clearApiKey();
                                        if (mounted) context.pop();
                                      } catch (e) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Failed to clear API key: ${e.toString()}',
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                if (currentApiKey != null)
                                  const SizedBox(width: 12),
                                DButton(
                                  label: currentApiKey != null
                                      ? 'Update'
                                      : 'Save',
                                  variant: DButtonVariant.primary,
                                  size: DButtonSize.sm,
                                  onTap: () async {
                                    if (_apiKeyController.text.isNotEmpty) {
                                      try {
                                        await tmdbNotifier.setApiKey(
                                          _apiKeyController.text,
                                        );
                                        if (mounted) context.pop();
                                      } catch (e) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Failed to save API key: ${e.toString()}',
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TmdbRequiredDrawer extends ConsumerWidget {
  const TmdbRequiredDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return GestureDetector(
      onTap: () {
        // Close keyboard if open
        FocusScope.of(context).unfocus();
      },
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 500 : double.infinity,
              maxHeight: isDesktop
                  ? 600
                  : MediaQuery.of(context).size.height * 0.9,
            ),
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1a1a1a),
              borderRadius: BorderRadius.circular(isDesktop ? 16 : 24),
              border: isDesktop ? Border.all(color: Colors.grey[800]!) : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDesktop ? 16 : 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isDesktop) ...[
                    // Handle bar for mobile
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                  Flexible(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with title and close button
                            Row(
                              children: [
                                const Text(
                                  'TMDB API Key Required',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                                DButton(
                                  icon: Icons.close,
                                  variant: DButtonVariant.ghost,
                                  size: DButtonSize.sm,
                                  onTap: () => context.pop(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'You need to configure your TMDB API key before adding library items. This ensures proper metadata fetching for movies and TV shows.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                DButton(
                                  label: 'Configure',
                                  variant: DButtonVariant.primary,
                                  size: DButtonSize.sm,
                                  onTap: () {
                                    context.pop(); // Close current drawer
                                    context.push('/drawer/tmdb-api-key');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
