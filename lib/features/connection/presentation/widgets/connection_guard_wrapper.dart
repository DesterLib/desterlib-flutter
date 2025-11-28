// External packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// App
import 'package:dester/app/providers/connection_guard_provider.dart';

// Core
import '../../domain/entities/connection_status.dart' as connection;
import 'm_connection_status.dart';

/// Wrapper widget that monitors connection status and shows modal/drawer when needed
class ConnectionGuardWrapper extends ConsumerStatefulWidget {
  final Widget child;
  final bool showOnError;
  final bool autoCheck;

  const ConnectionGuardWrapper({
    super.key,
    required this.child,
    this.showOnError = true,
    this.autoCheck = true,
  });

  @override
  ConsumerState<ConnectionGuardWrapper> createState() =>
      _ConnectionGuardWrapperState();
}

class _ConnectionGuardWrapperState
    extends ConsumerState<ConnectionGuardWrapper> {
  bool _hasShownError = false;
  bool _hasAutoNavigatedToApiManagement = false;
  bool _hasCompletedInitialCheck = false;

  @override
  Widget build(BuildContext context) {
    if (widget.autoCheck) {
      // Listen to connection status changes
      ref.listen<connection.ConnectionGuardState>(connectionGuardProvider, (
        previous,
        next,
      ) {
        // Check if this is the initial check (previous is null or was checking)
        final isInitialCheck =
            previous == null ||
            previous.status == connection.ConnectionStatus.checking;
        final isApiConnected =
            next.status == connection.ConnectionStatus.connected;
        final hasApiError = next.status == connection.ConnectionStatus.error;
        final hasNoApi = next.apiUrl == null || next.apiUrl!.isEmpty;

        // Mark initial check as completed when status changes from checking
        if (isInitialCheck &&
            previous?.status == connection.ConnectionStatus.checking &&
            next.status != connection.ConnectionStatus.checking) {
          _hasCompletedInitialCheck = true;
        }

        // Navigate to connection setup screen if no API is configured (only after initial check completes)
        if ((hasNoApi || hasApiError) &&
            !_hasAutoNavigatedToApiManagement &&
            _hasCompletedInitialCheck &&
            mounted &&
            context.mounted) {
          _hasAutoNavigatedToApiManagement = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              final currentLocation = GoRouterState.of(context).uri.path;
              // Only navigate if we're not already on the connection setup page
              if (currentLocation != '/connection-setup') {
                context.go('/connection-setup');
              }
            }
          });
        }

        // Navigate back to home when API connection is successful
        // Navigate if we're on the connection setup screen and API just connected
        if (isApiConnected &&
            _hasCompletedInitialCheck &&
            mounted &&
            context.mounted) {
          final currentLocation = GoRouterState.of(context).uri.path;
          // If we're on connection setup and API just became connected, navigate to home
          if (currentLocation == '/connection-setup' &&
              previous?.status != connection.ConnectionStatus.connected) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                context.go('/');
                _hasAutoNavigatedToApiManagement = false;
              }
            });
          }
        }

        // Show modal for later API errors (not initial load)
        if (widget.showOnError &&
            hasApiError &&
            !_hasShownError &&
            !isInitialCheck &&
            !isApiConnected &&
            !_hasAutoNavigatedToApiManagement &&
            mounted) {
          _hasShownError = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showConnectionModal();
          });
        } else if (isApiConnected) {
          _hasShownError = false;
        }
      });
    }

    // Always show child (navigation is handled via router)
    return widget.child;
  }

  void _showConnectionModal() {
    if (mounted && context.mounted) {
      ConnectionStatusModal.show(
        context,
        onRetry: () {
          ref.read(connectionGuardProvider.notifier).checkConnection();
        },
      );
    }
  }
}
