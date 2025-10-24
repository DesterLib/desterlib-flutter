import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dester/shared/widgets/ui/animated_app_bar_page.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AnimatedAppBarPage(
      title: 'Library',
      child: Center(child: Text('Coming soon...')),
    );
  }
}
