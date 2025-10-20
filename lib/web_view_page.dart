import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:desterlib_flutter/video_player/video_player.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? _controller;
  bool _bridgeInjected = false;

  String get _serverUrl {
    String url;
    if (Platform.isAndroid) {
      url = 'http://10.0.2.2:3001';
    } else if (Platform.isMacOS) {
      url = 'http://127.0.0.1:3001';
    } else {
      url = 'http://127.0.0.1:3001';
    }
    debugPrint('🌐 Loading URL: $url (Platform: ${Platform.operatingSystem})');
    return url;
  }

  void _onWebViewCreated(InAppWebViewController controller) {
    _controller = controller;

    // Register the playVideo handler
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
    debugPrint('🚀 Load START: $url');

    // Reset bridge state on new page load
    _bridgeInjected = false;

    // Prevent HTTPS redirects
    if (url != null && url.toString().startsWith('https://localhost:3001')) {
      debugPrint('🛑 Preventing HTTPS redirect');
      controller.loadUrl(
        urlRequest: URLRequest(
          url: WebUri(
            url.toString().replaceFirst(
              'https://localhost:3001',
              'http://127.0.0.1:3001',
            ),
          ),
        ),
      );
    }
  }

  void _onLoadStop(InAppWebViewController controller, WebUri? url) async {
    debugPrint('✅ Load STOP: $url');

    try {
      final pageTitle = await controller.getTitle();
      debugPrint('📄 Page title: $pageTitle');

      // Inject bridge once DOM is ready
      await _injectFlutterBridge();

      // Wait for React initialization and inject again
      await Future.delayed(const Duration(milliseconds: 500));
      await _ensureBridgeReady();
    } catch (e) {
      debugPrint('❌ Error after load: $e');
      await _injectFlutterBridge();
    }
  }

  Future<void> _injectFlutterBridge() async {
    if (_bridgeInjected) {
      debugPrint('⏭️ Bridge already injected, skipping');
      return;
    }

    try {
      await _controller?.evaluateJavascript(
        source: '''
          (function() {
            // Define the bridge functions
            window.flutterPlayVideo = function(videoData) {
              try {
                const message = typeof videoData === 'string' ? videoData : JSON.stringify(videoData);
                window.flutter_inappwebview.callHandler('playVideo', message);
                return Promise.resolve();
              } catch (e) {
                return Promise.reject(e);
              }
            };
            
            // Mark as Flutter WebView
            window.isFlutterWebView = true;
            
            // Dispatch ready event
            window.dispatchEvent(new CustomEvent('flutterBridgeReady'));
            
            return 'BRIDGE_READY';
          })();
        ''',
      );

      _bridgeInjected = true;
      debugPrint('✅ Flutter bridge successfully injected');
    } catch (e) {
      debugPrint('❌ Error injecting Flutter bridge: $e');
      _bridgeInjected = false;
    }
  }

  Future<void> _ensureBridgeReady() async {
    try {
      final result = await _controller?.evaluateJavascript(
        source: '''
          (function() {
            if (typeof window.flutterPlayVideo === 'function') {
              return 'READY';
            } else {
              return 'NOT_READY';
            }
          })();
        ''',
      );

      if (result == 'NOT_READY') {
        debugPrint('⚠️ Bridge verification failed, re-injecting...');
        _bridgeInjected = false;
        await _injectFlutterBridge();
      }
    } catch (e) {
      debugPrint('❌ Error verifying bridge: $e');
    }
  }

  void _onReceivedError(
    InAppWebViewController controller,
    WebResourceRequest request,
    WebResourceError error,
  ) {
    debugPrint('❌ ERROR loading: ${error.description}');
    debugPrint('❌ Error code: ${error.type}');
    debugPrint('❌ Request URL: ${request.url}');
  }

  void _handlePlayVideo(String message) {
    try {
      final data = jsonDecode(message) as Map<String, dynamic>;
      final streamUrl = data['url'] as String;
      final title = data['title'] as String?;

      debugPrint('🎬 Playing video: $title');

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              VideoPlayerPage(videoUrl: streamUrl, title: title),
        ),
      );
    } catch (e) {
      debugPrint('❌ Error handling playVideo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
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
