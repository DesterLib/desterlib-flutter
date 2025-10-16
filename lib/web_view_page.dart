import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:desterlib_flutter/video_player/video_player.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? _controller;

  bool _isLoading = true;
  String? _loadingStatus;
  bool _hasError = false;
  String? _errorMessage;
  bool _isUsingBundled = false;

  /// Get API server URL based on platform
  String get _apiServerUrl {
    if (kIsWeb) {
      return 'http://localhost:5173';
    }

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5173';
    }

    if (Platform.isIOS || Platform.isMacOS) {
      return 'http://localhost:5173';
    }

    return 'http://localhost:5173';
  }

  @override
  void initState() {
    super.initState();
    _loadWebApp();
  }

  /// Load web app: Try API server first, fallback to bundled assets
  Future<void> _loadWebApp() async {
    setState(() {
      _hasError = false;
      _isUsingBundled = false;
    });

    // Check network connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    final isOnline = connectivityResult != ConnectivityResult.none;

    if (isOnline) {
      final serverReachable = await _tryLoadFromServer();
      if (serverReachable) {
        debugPrint('✅ Will load from API server');
        setState(() => _isUsingBundled = false);
        return;
      }

      debugPrint('⚠️ API server not reachable, will use bundled assets...');
    } else {
      debugPrint('📴 No network connection, will use bundled assets...');
    }

    // Fallback to bundled assets
    setState(() => _isUsingBundled = true);
  }

  /// Try to check if API server is reachable
  Future<bool> _tryLoadFromServer() async {
    try {
      final url = _apiServerUrl;
      debugPrint('🌐 Checking API server: $url');

      final uri = Uri.parse(url);
      final socket = await Socket.connect(
        uri.host,
        uri.port,
        timeout: const Duration(seconds: 3),
      );
      socket.destroy();

      setState(() => _isUsingBundled = false);
      return true;
    } catch (e) {
      debugPrint('Failed to connect to API server: $e');
      return false;
    }
  }

  void _onWebViewCreated(InAppWebViewController controller) {
    _controller = controller;

    // Add JavaScript handlers for communication
    controller.addJavaScriptHandler(
      handlerName: 'playVideo',
      callback: (args) {
        if (args.isNotEmpty) {
          _handlePlayVideo(args[0].toString());
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'pickDirectory',
      callback: (args) {
        _handlePickDirectory();
      },
    );
  }

  void _onLoadStart(InAppWebViewController controller, WebUri? url) {
    debugPrint('✅ Page started loading: $url');
  }

  void _onLoadStop(InAppWebViewController controller, WebUri? url) async {
    debugPrint('✅ Page finished loading: $url');
    setState(() {
      _isLoading = false;
      _loadingStatus = null;
    });
  }

  void _onReceivedError(
    InAppWebViewController controller,
    WebResourceRequest request,
    WebResourceError error,
  ) {
    debugPrint('❌ Page load error: ${error.description} (code: ${error.type})');
  }

  void _onConsoleMessage(
    InAppWebViewController controller,
    ConsoleMessage consoleMessage,
  ) {
    debugPrint(
      '🌐 Console [${consoleMessage.messageLevel}]: ${consoleMessage.message}',
    );
  }

  Map<String, dynamic> _parseMessage(String message) {
    try {
      return jsonDecode(message) as Map<String, dynamic>;
    } catch (_) {
      String jsonString = message
          .replaceAllMapped(RegExp(r'(\w+):\s*([^,}]+)'), (match) {
            final key = match.group(1);
            final value = match.group(2)?.trim();
            if (value != null && double.tryParse(value) != null) {
              return '"$key": $value';
            }
            return '"$key": "$value"';
          })
          .replaceAll('{', '{"')
          .replaceFirst('{"', '{');
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
  }

  void _handlePlayVideo(String message) {
    debugPrint('📹 Received playVideo message: $message');

    try {
      final data = _parseMessage(message);
      final streamUrl = data['url'] as String;
      final title = data['title'] as String?;
      final season = data['season'] != null
          ? (data['season'] as num).toInt()
          : null;
      final episode = data['episode'] != null
          ? (data['episode'] as num).toInt()
          : null;
      final episodeTitle = data['episodeTitle'] as String?;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoPlayerPage(
            videoUrl: streamUrl,
            title: title,
            season: season,
            episode: episode,
            episodeTitle: episodeTitle,
          ),
        ),
      );
    } catch (e) {
      debugPrint('❌ Error handling playVideo message: $e');
    }
  }

  Future<void> _handlePickDirectory() async {
    debugPrint('📁 Opening directory picker...');

    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory != null) {
        debugPrint('✅ Directory selected: $selectedDirectory');
        final escapedPath = selectedDirectory
            .replaceAll('\\', '\\\\')
            .replaceAll("'", "\\'");
        await _controller?.evaluateJavascript(
          source:
              '''
          if (window.flutter_directory_callback) {
            window.flutter_directory_callback('$escapedPath');
          }
        ''',
        );
      }
    } catch (e) {
      debugPrint('❌ Error picking directory: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // WebView
          if (!_hasError)
            SafeArea(
              child: InAppWebView(
                initialUrlRequest: _isUsingBundled
                    ? null
                    : URLRequest(url: WebUri(_apiServerUrl)),
                initialFile: _isUsingBundled ? 'assets/web/index.html' : null,
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  allowFileAccessFromFileURLs: true,
                  allowUniversalAccessFromFileURLs: true,
                  useShouldOverrideUrlLoading: false,
                  mediaPlaybackRequiresUserGesture: false,
                  allowsInlineMediaPlayback: true,
                ),
                onWebViewCreated: _onWebViewCreated,
                onLoadStart: _onLoadStart,
                onLoadStop: _onLoadStop,
                onReceivedError: _onReceivedError,
                onConsoleMessage: _onConsoleMessage,
                onLoadResource: (controller, resource) {
                  debugPrint('Loading resource: ${resource.url}');
                },
              ),
            ),

          // Loading indicator
          if (_isLoading)
            Container(
              color: const Color(0xFF191919),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                    ),
                    if (_loadingStatus != null) ...[
                      const SizedBox(height: 24),
                      Text(
                        _loadingStatus!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),

          // Error screen
          if (_hasError)
            Container(
              color: const Color(0xFF191919),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _errorMessage ?? 'An error occurred',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _loadWebApp();
                          });
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Offline indicator badge
          if (_isUsingBundled && !_isLoading && !_hasError)
            Positioned(
              top: 8,
              right: 8,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wifi_off, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Offline Mode',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
