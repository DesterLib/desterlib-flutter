import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:desterlib_flutter/video_player/video_player.dart';
import 'package:desterlib_flutter/services/network_discovery_service.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? _controller;
  bool _bridgeInjected = false;
  String _serverUrl = '';
  bool _isDiscovering = true;

  @override
  void initState() {
    super.initState();
    _discoverAndSetServerUrl();
  }

  Future<void> _discoverAndSetServerUrl() async {
    try {
      final discoveredUrl = await NetworkDiscoveryService.getBestServerUrl();

      if (mounted) {
        setState(() {
          _serverUrl = discoveredUrl;
          _isDiscovering = false;
        });

        // Reload the webview with the discovered URL
        if (_controller != null) {
          await _controller!.loadUrl(
            urlRequest: URLRequest(url: WebUri(discoveredUrl)),
          );
        }
      }
    } catch (e) {
      debugPrint('Error discovering server: $e');
      if (mounted) {
        setState(() {
          // Fallback to localhost URL
          if (Platform.isAndroid) {
            _serverUrl = 'http://10.0.2.2:3001';
          } else {
            _serverUrl = 'http://127.0.0.1:3001';
          }
          _isDiscovering = false;
        });
      }
    }
  }

  void _onWebViewCreated(InAppWebViewController controller) {
    _controller = controller;
    controller.addJavaScriptHandler(
      handlerName: 'playVideo',
      callback: (args) {
        if (args.isNotEmpty) {
          _handlePlayVideo(args[0].toString());
        }
      },
    );
  }

  void _onLoadStart(InAppWebViewController controller, WebUri? url) {
    _bridgeInjected = false;

    // Prevent HTTPS redirects for local development
    if (url != null &&
        url.toString().contains('https://') &&
        url.toString().contains(':3001')) {
      final httpUrl = url.toString().replaceFirst('https://', 'http://');
      controller.loadUrl(urlRequest: URLRequest(url: WebUri(httpUrl)));
    }
  }

  void _onLoadStop(InAppWebViewController controller, WebUri? url) async {
    try {
      // Inject bridge once DOM is ready
      await _injectFlutterBridge();

      // Wait for React initialization and ensure bridge is ready
      await Future.delayed(const Duration(milliseconds: 500));
      await _ensureBridgeReady();
    } catch (e) {
      debugPrint('Error after load: $e');
      await _injectFlutterBridge();
    }
  }

  Future<void> _injectFlutterBridge() async {
    if (_bridgeInjected) return;

    try {
      await _controller?.evaluateJavascript(
        source: '''
          (function() {
            window.flutterPlayVideo = function(videoData) {
              try {
                const message = typeof videoData === 'string' ? videoData : JSON.stringify(videoData);
                window.flutter_inappwebview.callHandler('playVideo', message);
                return Promise.resolve();
              } catch (e) {
                return Promise.reject(e);
              }
            };
            
            window.isFlutterWebView = true;
            window.dispatchEvent(new CustomEvent('flutterBridgeReady'));
            return 'BRIDGE_READY';
          })();
        ''',
      );

      _bridgeInjected = true;
    } catch (e) {
      debugPrint('Error injecting Flutter bridge: $e');
      _bridgeInjected = false;
    }
  }

  Future<void> _ensureBridgeReady() async {
    try {
      final result = await _controller?.evaluateJavascript(
        source: '''
          (function() {
            return typeof window.flutterPlayVideo === 'function' ? 'READY' : 'NOT_READY';
          })();
        ''',
      );

      if (result == 'NOT_READY') {
        _bridgeInjected = false;
        await _injectFlutterBridge();
      }
    } catch (e) {
      debugPrint('Error verifying bridge: $e');
    }
  }

  void _onReceivedError(
    InAppWebViewController controller,
    WebResourceRequest request,
    WebResourceError error,
  ) {
    debugPrint(
      'WebView error: ${error.description} (${error.type}) at ${request.url}',
    );
  }

  void _handlePlayVideo(String message) {
    try {
      final data = jsonDecode(message) as Map<String, dynamic>;
      final streamUrl = data['url'] as String;
      final title = data['title'] as String?;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              VideoPlayerPage(videoUrl: streamUrl, title: title),
        ),
      );
    } catch (e) {
      debugPrint('Error handling playVideo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isDiscovering || _serverUrl.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Discovering API server on network...'),
                  ],
                ),
              )
            : InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(_serverUrl)),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  allowsInlineMediaPlayback: true,
                  mediaPlaybackRequiresUserGesture: false,
                  allowsBackForwardNavigationGestures: false,
                  cacheEnabled: false,
                  clearCache: true,
                  hardwareAcceleration: true,
                  userAgent:
                      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 DesterFlutterWebView/1.0',
                  mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                  transparentBackground: false,
                  supportZoom: false,
                  incognito: false,
                ),
                onWebViewCreated: _onWebViewCreated,
                onLoadStart: _onLoadStart,
                onLoadStop: _onLoadStop,
                onReceivedError: _onReceivedError,
              ),
      ),
    );
  }
}
