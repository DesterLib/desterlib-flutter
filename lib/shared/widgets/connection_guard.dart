import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/connection_provider.dart';
import '../../features/settings/presentation/modals/api_connection_modal.dart';
import '../../shared/utils/platform_icons.dart';
import 'ui/button.dart';

class ConnectionGuard extends ConsumerWidget {
  final Widget child;

  const ConnectionGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionStatus = ref.watch(connectionStatusProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: _buildContent(context, connectionStatus),
    );
  }

  Widget _buildContent(BuildContext context, ConnectionStatus status) {
    // If checking connection, show loading
    if (status == ConnectionStatus.checking) {
      return Scaffold(
        key: const ValueKey('checking'),
        backgroundColor: const Color(0xFF0a0a0a),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RepaintBoundary(
                child: const CupertinoActivityIndicator(
                  color: Colors.white,
                  radius: 16,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Checking API connection...',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // If disconnected, show connection prompt
    if (status == ConnectionStatus.disconnected) {
      return Scaffold(
        key: const ValueKey('disconnected'),
        backgroundColor: const Color(0xFF0a0a0a),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  PlatformIcons.errorCircle,
                  size: 64,
                  color: Colors.red[400],
                ),
                const SizedBox(height: 24),
                const Text(
                  'API Not Connected',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Please configure your API connection to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                ),
                const SizedBox(height: 32),
                DButton(
                  label: 'Configure Connection',
                  variant: DButtonVariant.primary,
                  size: DButtonSize.sm,
                  onTap: () => ApiConnectionModal.show(context),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // If connected, show the child widget
    if (status == ConnectionStatus.connected) {
      return Container(key: const ValueKey('connected'), child: child);
    }

    return const SizedBox.shrink();
  }
}
