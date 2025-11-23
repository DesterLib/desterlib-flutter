// External packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// App
import 'package:dester/app/providers/connection_guard_provider.dart';

// Core
import 'package:dester/core/connection/presentation/screens/s_connection.dart';
import 'package:dester/core/constants/app_constants.dart';

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
  bool _shouldShowConnectionScreen = true; // Always show on initial load
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

        // Mark initial check as completed when status changes from checking
        if (isInitialCheck &&
            previous?.status == connection.ConnectionStatus.checking &&
            next.status != connection.ConnectionStatus.checking) {
          _hasCompletedInitialCheck = true;
        }

        // Hide connection screen when API connection is successful after initial check
        if (isApiConnected &&
            _shouldShowConnectionScreen &&
            _hasCompletedInitialCheck) {
          setState(() {
            _shouldShowConnectionScreen = false;
          });
        }
        // Show modal for later API errors (not initial load)
        else if (widget.showOnError &&
            hasApiError &&
            !_hasShownError &&
            !isInitialCheck &&
            !isApiConnected &&
            !_shouldShowConnectionScreen &&
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

    // Show connection screen if needed, otherwise show child with fade animation
    return AnimatedSwitcher(
      duration: AppConstants.fadeTransition,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _shouldShowConnectionScreen
          ? const ConnectionScreen(key: ValueKey('connection_screen'))
          : KeyedSubtree(
              key: const ValueKey('app_content'),
              child: widget.child,
            ),
    );
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
