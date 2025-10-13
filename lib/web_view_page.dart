import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:desterlib_flutter/video_player_page.dart';

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

  Map<String, dynamic> _parseMessage(String message) {
    // Try to parse as standard JSON first
    try {
      return jsonDecode(message) as Map<String, dynamic>;
    } catch (_) {
      // If that fails, try to convert the object notation to valid JSON
      // Handle format: {key: value, ...} -> {"key": "value", ...}
      String jsonString = message
          .replaceAllMapped(RegExp(r'(\w+):\s*([^,}]+)'), (match) {
            final key = match.group(1);
            final value = match.group(2)?.trim();

            // Check if value is a number
            if (value != null && double.tryParse(value) != null) {
              return '"$key": $value';
            }
            // Otherwise treat as string
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
      // Handle both int and double for season/episode
      final season = data['season'] != null
          ? (data['season'] as num).toInt()
          : null;
      final episode = data['episode'] != null
          ? (data['episode'] as num).toInt()
          : null;
      final episodeTitle = data['episodeTitle'] as String?;

      debugPrint('Playing video from: $streamUrl');
      if (title != null) {
        debugPrint('Title: $title');
        if (season != null && episode != null) {
          debugPrint('Season $season, Episode $episode');
          if (episodeTitle != null) {
            debugPrint('Episode title: $episodeTitle');
          }
        }
      }

      // Navigate to video player page
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}
