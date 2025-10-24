import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dester/shared/widgets/ui/animated_app_bar_page.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import '../../../../core/providers/connection_provider.dart';
import '../../../../core/config/api_config.dart';

class ApiConnectionScreen extends ConsumerStatefulWidget {
  const ApiConnectionScreen({super.key});

  @override
  ConsumerState<ApiConnectionScreen> createState() =>
      _ApiConnectionScreenState();
}

class _ApiConnectionScreenState extends ConsumerState<ApiConnectionScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool _isConnecting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCurrentUrl();
  }

  Future<void> _loadCurrentUrl() async {
    await ApiConfig.loadBaseUrl();
    if (mounted) {
      setState(() {
        _urlController.text = ApiConfig.baseUrl;
      });
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    setState(() {
      _isConnecting = true;
      _errorMessage = null;
    });

    try {
      // Save the new URL first
      await ApiConfig.saveBaseUrl(_urlController.text.trim());

      // Test the connection
      final connectionNotifier = ref.read(connectionStatusProvider.notifier);
      await connectionNotifier.checkConnection();

      // Wait a bit for the status to update
      await Future.delayed(const Duration(milliseconds: 200));

      final status = ref.read(connectionStatusProvider);
      if (status == ConnectionStatus.connected) {
        if (mounted) {
          context.go('/settings');
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to connect to API server';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isConnecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectionStatus = ref.watch(connectionStatusProvider);

    return AnimatedAppBarPage(
      title: 'API Connection',
      maxWidthConstraint: 1220,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Connection status indicator
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: connectionStatus == ConnectionStatus.connected
                          ? Colors.green
                          : connectionStatus == ConnectionStatus.disconnected
                          ? Colors.red
                          : Colors.orange,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        connectionStatus == ConnectionStatus.connected
                            ? PlatformIcons.checkCircle
                            : connectionStatus == ConnectionStatus.disconnected
                            ? PlatformIcons.errorCircle
                            : PlatformIcons.loading,
                        color: connectionStatus == ConnectionStatus.connected
                            ? Colors.green
                            : connectionStatus == ConnectionStatus.disconnected
                            ? Colors.red
                            : Colors.orange,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              connectionStatus == ConnectionStatus.connected
                                  ? 'Connected'
                                  : connectionStatus ==
                                        ConnectionStatus.disconnected
                                  ? 'Disconnected'
                                  : 'Checking...',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              connectionStatus == ConnectionStatus.connected
                                  ? 'API server is reachable'
                                  : connectionStatus ==
                                        ConnectionStatus.disconnected
                                  ? 'Cannot reach API server'
                                  : 'Testing connection...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // API URL input
                const Text(
                  'API Server URL',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _urlController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'http://localhost:3000',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF00FFB3)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Error message
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          PlatformIcons.errorCircle,
                          color: Colors.red[400],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Colors.red[400],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Action buttons
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    final isConnected =
                        connectionStatus == ConnectionStatus.connected;

                    if (isMobile) {
                      // Stack buttons vertically on mobile
                      return Column(
                        children: [
                          DButton(
                            label: _isConnecting ? 'Saving...' : 'Save & Test',
                            variant: DButtonVariant.primary,
                            size: DButtonSize.md,
                            fullWidth: true,
                            onTap: _isConnecting ? null : _testConnection,
                          ),
                          if (isConnected) ...[
                            const SizedBox(height: 12),
                            DButton(
                              label: 'Cancel',
                              variant: DButtonVariant.ghost,
                              size: DButtonSize.md,
                              fullWidth: true,
                              onTap: () => context.pop(),
                            ),
                          ],
                        ],
                      );
                    } else {
                      // Side by side on desktop, not full width
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DButton(
                            label: _isConnecting ? 'Saving...' : 'Save & Test',
                            variant: DButtonVariant.primary,
                            size: DButtonSize.md,
                            onTap: _isConnecting ? null : _testConnection,
                          ),
                          if (isConnected) ...[
                            const SizedBox(width: 16),
                            DButton(
                              label: 'Cancel',
                              variant: DButtonVariant.ghost,
                              size: DButtonSize.md,
                              onTap: () => context.pop(),
                            ),
                          ],
                        ],
                      );
                    }
                  },
                ),

                const SizedBox(height: 32),

                // Help text
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            PlatformIcons.info,
                            color: Colors.blue[400],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Connection Help',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Make sure your Dester API server is running and accessible. The default URL is usually http://localhost:3001 for local development.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
