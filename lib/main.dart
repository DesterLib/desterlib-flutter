import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'app/app.dart';
import 'core/bootstrap.dart';

void main() async {
  // Preserve the native splash screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await bootstrap();

  // The base URL will be loaded from ApiConfig in the provider's build method
  runApp(const ProviderScope(child: App()));

  // Remove native splash after runApp to prevent black screen on iOS
  // This ensures the app widget tree has started building before removing native splash
  await Future.delayed(const Duration(milliseconds: 100));
  FlutterNativeSplash.remove();
}
