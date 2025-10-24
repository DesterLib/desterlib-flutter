import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/connection_provider.dart';
import '../../features/settings/presentation/screens/api_connection_screen.dart';

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

    // If disconnected, show connection screen
    if (connectionStatus == ConnectionStatus.disconnected) {
      return const ApiConnectionScreen();
    }

    // If connected, show the child widget
    if (connectionStatus == ConnectionStatus.connected) {
      return child;
    }

    return const SizedBox.shrink();
  }
}
