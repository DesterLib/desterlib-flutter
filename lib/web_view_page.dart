import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dester_flutter/video_player_page.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  String get _webServerUrl {
    // For web platform, return a default URL (webview won't work on web anyway)
    if (kIsWeb) {
      return 'http://localhost:5173';
    }

    // For Android emulator, use special alias
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5173';
    }

    // For iOS simulator and macOS, localhost works fine
    if (Platform.isIOS || Platform.isMacOS) {
      return 'http://localhost:5173';
    }

    // For Windows and Linux, localhost should work
    // For physical devices, you'll need to replace this with your machine's IP
    return 'http://localhost:5173';
  }

  @override
  void initState() {
    super.initState();

    final url = _webServerUrl;
    debugPrint('Initializing WebView with URL: $url');

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('✅ Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('✅ Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('❌ Page resource error:');
            debugPrint('   Description: ${error.description}');
            debugPrint('   Error code: ${error.errorCode}');
            debugPrint('   Error type: ${error.errorType}');
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('❌ HTTP error: ${error.response?.statusCode}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'playVideo',
        onMessageReceived: (JavaScriptMessage message) {
          _handlePlayVideo(message.message);
        },
      )
      ..loadRequest(Uri.parse(url));

    // setBackgroundColor is not supported on macOS
    if (!kIsWeb && !Platform.isMacOS) {
      _controller.setBackgroundColor(const Color(0x00000000));
    }
  }

  void _handlePlayVideo(String message) {
    debugPrint('📹 Received playVideo message: $message');

    try {
      String streamUrl;

      // Try to parse as JSON first
      try {
        final data = jsonDecode(message) as Map<String, dynamic>;
        streamUrl = data['url'] as String;
      } catch (_) {
        // If JSON parsing fails, try to extract URL using regex
        // Handle format like: {url: http://...}
        final match = RegExp(r'url:\s*([^\s}]+)').firstMatch(message);
        if (match != null) {
          streamUrl = match.group(1)!;
        } else {
          throw Exception('Could not extract URL from message: $message');
        }
      }

      debugPrint('Playing video from: $streamUrl');

      // Navigate to video player page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoPlayerPage(videoUrl: streamUrl),
        ),
      );
    } catch (e) {
      debugPrint('❌ Error handling playVideo message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}
