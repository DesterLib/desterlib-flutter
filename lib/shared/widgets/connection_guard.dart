import 'package:flutter/material.dart';
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

    // If checking connection, show loading
    if (connectionStatus == ConnectionStatus.checking) {
      return const Scaffold(
        backgroundColor: Color(0xFF0a0a0a),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00FFB3)),
              ),
              SizedBox(height: 16),
              Text(
                'Checking API connection...',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // If disconnected, show connection prompt
    if (connectionStatus == ConnectionStatus.disconnected) {
      return Scaffold(
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
    if (connectionStatus == ConnectionStatus.connected) {
      return child;
    }

    return const SizedBox.shrink();
  }
}
