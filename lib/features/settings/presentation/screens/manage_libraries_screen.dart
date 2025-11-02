import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/shared/widgets/ui/animated_app_bar_page.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:dester/features/library/data/providers/library_provider.dart';

class ManageLibrariesScreen extends ConsumerWidget {
  const ManageLibrariesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final librariesAsync = ref.watch(actualLibrariesProvider);

    return AnimatedAppBarPage(
      title: 'Manage Libraries',
      maxWidthConstraint: 1220,
      child: librariesAsync.when(
        data: (libraries) {
          if (libraries.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.video_library_outlined,
                      size: 64,
                      color: Colors.white24,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No libraries found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Libraries will appear here once you scan your media folders',
                      style: TextStyle(fontSize: 14, color: Colors.white54),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: libraries.length,
                itemBuilder: (context, index) {
                  final library = libraries[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[600]!),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(20),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getLibraryIcon(library.libraryType),
                          color: Colors.white70,
                          size: 24,
                        ),
                      ),
                      title: Text(
                        library.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            library.libraryType != null
                                ? _getLibraryTypeDisplayName(
                                    library.libraryType!,
                                  )
                                : 'Unknown Type',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          if (library.description != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              library.description!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white54,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          if (library.libraryPath != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              library.libraryPath!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white38,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white70),
                            onPressed: () {
                              context.push(
                                '/settings/manage-libraries/edit/${library.id}',
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.push(
                                '/settings/manage-libraries/delete/${library.id}',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          );
        },
        loading: () => Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
        error: (error, stack) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Error loading libraries',
                  style: TextStyle(
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
                  onPressed: () {
                    ref.invalidate(actualLibrariesProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getLibraryIcon(ModelLibraryLibraryTypeEnum? type) {
    switch (type) {
      case ModelLibraryLibraryTypeEnum.MOVIE:
        return PlatformIcons.movie;
      case ModelLibraryLibraryTypeEnum.TV_SHOW:
        return PlatformIcons.videoLibrary;
      case ModelLibraryLibraryTypeEnum.MUSIC:
        return PlatformIcons.playCircle;
      case ModelLibraryLibraryTypeEnum.COMIC:
        return PlatformIcons.libraryBooks;
      default:
        return PlatformIcons.videoLibrary;
    }
  }

  String _getLibraryTypeDisplayName(ModelLibraryLibraryTypeEnum type) {
    if (type == ModelLibraryLibraryTypeEnum.MOVIE) return 'Movies';
    if (type == ModelLibraryLibraryTypeEnum.TV_SHOW) return 'TV Shows';
    if (type == ModelLibraryLibraryTypeEnum.MUSIC) return 'Music';
    if (type == ModelLibraryLibraryTypeEnum.COMIC) return 'Comics';
    return 'Unknown';
  }
}
