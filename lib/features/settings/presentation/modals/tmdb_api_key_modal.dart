import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dester/shared/widgets/modals/settings_modal_wrapper.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/app/theme/theme.dart';
import '../../data/tmdb_settings_provider.dart';

class TmdbApiKeyModal {
  static Future<bool?> show(BuildContext context) {
    return showSettingsModal<bool>(
      context: context,
      title: 'TMDB API Key',
      builder: (context) => const _TmdbApiKeyModalContent(),
    );
  }
}

class _TmdbApiKeyModalContent extends ConsumerStatefulWidget {
  const _TmdbApiKeyModalContent();

  @override
  ConsumerState<_TmdbApiKeyModalContent> createState() =>
      _TmdbApiKeyModalContentState();
}

class _TmdbApiKeyModalContentState
    extends ConsumerState<_TmdbApiKeyModalContent> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCurrentApiKey();
  }

  void _loadCurrentApiKey() {
    final currentApiKey = ref.read(tmdbSettingsProvider);
    if (currentApiKey != null) {
      _apiKeyController.text = currentApiKey;
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _saveApiKey() async {
    if (_apiKeyController.text.isEmpty) {
      setState(() {
        _errorMessage = 'API key cannot be empty';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(tmdbSettingsProvider.notifier)
          .setApiKey(_apiKeyController.text.trim());
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to save API key: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _clearApiKey() async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await ref.read(tmdbSettingsProvider.notifier).clearApiKey();
      if (mounted) {
        Navigator.of(context).pop(false);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to clear API key: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentApiKey = ref.watch(tmdbSettingsProvider);
    final hasExistingKey = currentApiKey != null && currentApiKey.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SettingsModalBanner(
          message:
              'Enter your TMDB API key to enable library management features.',
          type: SettingsModalBannerType.info,
        ),
        if (_errorMessage != null)
          SettingsModalBanner(
            message: _errorMessage!,
            type: SettingsModalBannerType.error,
          ),
        SettingsModalTextField(
          controller: _apiKeyController,
          label: 'API Key',
          hintText: 'Enter your TMDB API key',
          enabled: !_isSaving,
        ),
        SettingsModalSection(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Text(
            'Get your API key from: https://www.themoviedb.org/settings/api',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ),
        SettingsModalActions(
          actions: [
            if (hasExistingKey)
              DButton(
                label: _isSaving ? 'Clearing...' : 'Clear',
                variant: DButtonVariant.danger,
                size: DButtonSize.sm,
                onTap: _isSaving ? null : _clearApiKey,
              ),
            DButton(
              label: _isSaving
                  ? 'Saving...'
                  : (hasExistingKey ? 'Update' : 'Save'),
              variant: DButtonVariant.primary,
              size: DButtonSize.sm,
              icon: Icons.key,
              onTap: _isSaving ? null : _saveApiKey,
            ),
          ],
        ),
      ],
    );
  }
}
