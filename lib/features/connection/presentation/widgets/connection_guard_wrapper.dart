// External packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// App
import 'package:dester/app/providers/connection_guard_provider.dart';

// Core
import '../../domain/entities/connection_status.dart' as connection;
import 'connection_loading_pill.dart';
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
  bool _isConnectionSuccess = false;
  bool _shouldHideLoadingScreen = false;

  @override
  Widget build(BuildContext context) {
    // Watch current state
    final connectionState = ref.watch(connectionGuardProvider);
    final status = connectionState.status;

    // Use a listener for navigation effects to avoid build-phase navigation
    if (widget.autoCheck) {
      ref.listen<connection.ConnectionGuardState>(connectionGuardProvider, (
        previous,
        next,
      ) {
        if (!mounted) return;

        final isApiConnected =
            next.status == connection.ConnectionStatus.connected;
        final hasApiError = next.status == connection.ConnectionStatus.error;
        final hasNoApi = next.apiUrl == null || next.apiUrl!.isEmpty;

        // Trigger success animation when connection succeeds
        if (isApiConnected && !_isConnectionSuccess) {
          // Use post frame callback to ensure widget is built
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _isConnectionSuccess = true;
              });
            }
          });
        }

        // Navigation logic handled in post frame callback
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final currentLocation = GoRouterState.of(context).uri.path;

          // Case 1: No API or API Error -> Go to Setup (if not already there)
          if ((hasNoApi || hasApiError) &&
              currentLocation != '/connection-setup') {
            context.go('/connection-setup');
            return;
          }

          // Case 2: Connected -> Go to Home (if on Setup)
          if (isApiConnected && currentLocation == '/connection-setup') {
            context.go('/');
            return;
          }

          // Case 3: Connected -> Clear error flag
          if (isApiConnected) {
            _hasShownError = false;
          }

          // Case 4: Error -> Show modal (if not on setup and hasn't shown yet)
          // We don't show modal on setup screen as it handles its own errors visually
          if (widget.showOnError &&
              hasApiError &&
              !_hasShownError &&
              currentLocation != '/connection-setup') {
            _hasShownError = true;
            _showConnectionModal();
          }
        });
      });
    }

    // While checking initial connection state, show loading
    // Show loading screen until animation completes
    if (widget.autoCheck &&
        (status == connection.ConnectionStatus.checking ||
            !_shouldHideLoadingScreen)) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConnectionLoadingPill(
                isSuccess: _isConnectionSuccess,
                onAnimationComplete: () {
                  if (mounted) {
                    setState(() {
                      _shouldHideLoadingScreen = true;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Connecting to Dester...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Otherwise render the app
    return widget.child;
  }

  void _showConnectionModal() {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => const ConnectionStatusModal(),
    );
  }
}
