import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dester/shared/widgets/ui/animated_app_bar_page.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/features/library/data/providers/library_provider.dart';

class DeleteLibraryScreen extends ConsumerWidget {
  final String libraryId;

  const DeleteLibraryScreen({super.key, required this.libraryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final librariesAsync = ref.watch(actualLibrariesProvider);
    final managementState = ref.watch(libraryManagementProvider);

    return AnimatedAppBarPage(
      title: 'Delete Library',
      maxWidthConstraint: 600,
      child: librariesAsync.when(
        data: (libraries) {
          final library = libraries.firstWhere(
            (lib) => lib.id == libraryId,
            orElse: () => throw Exception('Library not found'),
          );

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Are you sure you want to delete "${library.name}"?',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'This will also delete all media entries that belong exclusively to this library.',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: const Text(
                    'Warning: This action cannot be undone. Media files on disk will not be deleted.',
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ),

                const SizedBox(height: 24),

                // Error message
                if (managementState.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      managementState.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DButton(
                      label: 'Cancel',
                      variant: DButtonVariant.ghost,
                      size: DButtonSize.sm,
                      onTap: () => context.pop(),
                    ),
                    const SizedBox(width: 12),
                    DButton(
                      label: managementState.isLoading
                          ? 'Deleting...'
                          : 'Delete',
                      variant: DButtonVariant.danger,
                      size: DButtonSize.sm,
                      onTap: managementState.isLoading
                          ? null
                          : () async {
                              try {
                                await ref
                                    .read(libraryManagementProvider.notifier)
                                    .deleteLibrary(library.id);
                                if (context.mounted) context.pop();
                              } catch (e) {
                                // Error is handled by the provider
                              }
                            },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading library',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: const TextStyle(fontSize: 14, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
