import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/connection_guard_provider.dart';
import '../../domain/entities/connection_status.dart' as connection;
import 'connection_status_modal.dart';

/// Wrapper widget that monitors connection status and shows modal/drawer when needed
class ConnectionGuardWrapper extends ConsumerStatefulWidget {
  final Widget child;
  final bool showOnError;
  final bool autoCheck;
  final GlobalKey<NavigatorState>? navigatorKey;

  const ConnectionGuardWrapper({
    super.key,
    required this.child,
    this.showOnError = true,
    this.autoCheck = true,
    this.navigatorKey,
  });

  @override
  ConsumerState<ConnectionGuardWrapper> createState() =>
      _ConnectionGuardWrapperState();
}

class _ConnectionGuardWrapperState
    extends ConsumerState<ConnectionGuardWrapper> {
  bool _hasShownError = false;

  @override
  Widget build(BuildContext context) {
    if (widget.autoCheck) {
      // Listen to connection status changes
      ref.listen<connection.ConnectionGuardState>(connectionGuardProvider, (
        previous,
        next,
      ) {
        if (widget.showOnError &&
            (next.status == connection.ConnectionStatus.error ||
                next.status == connection.ConnectionStatus.disconnected) &&
            !_hasShownError &&
            mounted) {
          _hasShownError = true;
          // Delay to ensure navigator is ready
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showConnectionModal();
          });
        } else if (next.status == connection.ConnectionStatus.connected) {
          _hasShownError = false;
        }
      });
    }

    return widget.child;
  }

  void _showConnectionModal() {
    final navigatorContext = widget.navigatorKey?.currentContext ?? context;
    if (navigatorContext.mounted) {
      ConnectionStatusModal.show(
        navigatorContext,
        onRetry: () {
          ref.read(connectionGuardProvider.notifier).checkConnection();
        },
      );
    }
  }
}
