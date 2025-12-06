// Dart
import 'dart:async';

// External packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// App
import 'package:dester/app/providers/connection_guard_provider.dart';

// Core
import '../../domain/entities/connection_status.dart' as connection;
import 'connection_loading_pill.dart';

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
  bool _isTransitioning = false;
  Timer? _loadingTimeoutTimer;
  Timer? _transitionTimer;

  @override
  void dispose() {
    _loadingTimeoutTimer?.cancel();
    _transitionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch current state
    final connectionState = ref.watch(connectionGuardProvider);
    final status = connectionState.status;
    final hasNoApi =
        connectionState.apiUrl == null || connectionState.apiUrl!.isEmpty;

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

        // Cancel timeout if connection succeeds
        if (isApiConnected) {
          _loadingTimeoutTimer?.cancel();
          _loadingTimeoutTimer = null;
        }

        // Navigation logic handled in post frame callback
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final router = GoRouter.of(context);
          final currentLocation = GoRouterState.of(context).uri.path;

          // Case 1: No API or API Error -> Go to Setup (if not already there)
          if ((hasNoApi || hasApiError) &&
              currentLocation != '/connection-setup') {
            // Cancel loading timeout since we're handling the transition
            _loadingTimeoutTimer?.cancel();
            _loadingTimeoutTimer = null;

            // Set transitioning state to keep loading screen visible during fade
            setState(() {
              _isTransitioning = true;
              // Don't hide loading screen yet - let transition complete first
            });

            // Navigate after a brief delay to ensure fade animation is visible
            Future.delayed(const Duration(milliseconds: 100), () {
              if (!mounted) return;
              router.go('/connection-setup');
              // Clear transitioning state and hide loading screen after animation duration
              _transitionTimer?.cancel();
              _transitionTimer = Timer(const Duration(milliseconds: 300), () {
                if (!mounted) return;
                setState(() {
                  _isTransitioning = false;
                  _shouldHideLoadingScreen = true;
                });
              });
            });
            return;
          }

          // Case 2: Connected -> Go to Home (if on Setup)
          if (isApiConnected && currentLocation == '/connection-setup') {
            router.go('/');
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

    // Set up timeout to hide loading screen if check takes too long
    if (widget.autoCheck &&
        status == connection.ConnectionStatus.checking &&
        !_shouldHideLoadingScreen &&
        _loadingTimeoutTimer == null) {
      _loadingTimeoutTimer = Timer(const Duration(seconds: 15), () {
        if (mounted) {
          // Check current status from provider
          final currentState = ref.read(connectionGuardProvider);
          if (currentState.status == connection.ConnectionStatus.checking) {
            setState(() {
              _shouldHideLoadingScreen = true;
            });
          }
        }
      });
    }

    // Cancel timeout if status is no longer checking
    if (status != connection.ConnectionStatus.checking) {
      _loadingTimeoutTimer?.cancel();
      _loadingTimeoutTimer = null;
    }

    // Get current location to check if we're on connection-setup
    final currentLocation = GoRouterState.of(context).uri.path;
    final isOnConnectionSetup = currentLocation == '/connection-setup';

    // Show loading screen while checking connection status
    // Also show loading screen if we have an error and we're not on connection-setup yet
    // This prevents the home screen from flashing before navigation completes
    final hasApiError = status == connection.ConnectionStatus.error;
    final isChecking = status == connection.ConnectionStatus.checking;

    // Determine if we should show loading screen
    final shouldShowLoading =
        widget.autoCheck &&
        (
        // Show while checking (unless timeout occurred)
        (isChecking && !_shouldHideLoadingScreen) ||
            // Show if error occurred and we're not on connection-setup yet (prevents home screen flash)
            (hasApiError &&
                !isOnConnectionSetup &&
                !hasNoApi &&
                !_shouldHideLoadingScreen) ||
            // Show during transition to allow fade animation (this takes priority)
            _isTransitioning);

    // Determine if we should render the app
    // Only render if connected, or on connection-setup screen, or autoCheck is disabled
    final shouldRenderApp =
        status == connection.ConnectionStatus.connected ||
        isOnConnectionSetup ||
        !widget.autoCheck;

    // Build loading screen widget with black background to match app
    final loadingScreen = Container(
      color: Colors.black,
      child: Center(
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

    // Use Stack to pre-render child behind loading screen for seamless transition
    // This ensures the app content is ready when we fade out the loading screen
    return Stack(
      fit: StackFit.expand,
      children: [
        // Pre-render the app content behind the loading screen when it should be rendered
        // This makes the transition seamless as the content is already built
        if (shouldRenderApp) widget.child,
        // Show loading screen on top with fade transition
        // The loading screen will fade out smoothly, revealing the pre-rendered content underneath
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          key: ValueKey<bool>(shouldShowLoading || !shouldRenderApp),
          child: (shouldShowLoading || !shouldRenderApp)
              ? Container(key: const ValueKey('loading'), child: loadingScreen)
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      ],
    );
  }

  void _showConnectionModal() {
    if (!mounted) return;

    // Navigate to manage APIs page instead of showing modal
    context.go('/settings/manage-apis');
  }
}
