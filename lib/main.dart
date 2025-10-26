import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'core/bootstrap.dart';

void main() async {
  await bootstrap();

  // The base URL will be loaded from ApiConfig in the provider's build method
  runApp(const ProviderScope(child: App()));
}
