import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/shared/widgets/ui/animated_app_bar_page.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/features/library/data/providers/library_provider.dart';

class EditLibraryScreen extends ConsumerStatefulWidget {
  final String libraryId;

  const EditLibraryScreen({super.key, required this.libraryId});

  @override
  ConsumerState<EditLibraryScreen> createState() => _EditLibraryScreenState();
}

class _EditLibraryScreenState extends ConsumerState<EditLibraryScreen> {
  final TextEditingController _libraryNameController = TextEditingController();
  final TextEditingController _libraryDescriptionController =
      TextEditingController();
  final TextEditingController _libraryPathController = TextEditingController();
  ModelLibraryLibraryTypeEnum? selectedType;

  @override
  void dispose() {
    _libraryNameController.dispose();
    _libraryDescriptionController.dispose();
    _libraryPathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final librariesAsync = ref.watch(actualLibrariesProvider);
    final managementState = ref.watch(libraryManagementProvider);

    return AnimatedAppBarPage(
      title: 'Edit Library',
      maxWidthConstraint: 600,
      child: librariesAsync.when(
        data: (libraries) {
          final library = libraries.firstWhere(
            (lib) => lib.id == widget.libraryId,
            orElse: () => throw Exception('Library not found'),
          );

          // Initialize controllers if not already done
          if (_libraryNameController.text.isEmpty) {
            _libraryNameController.text = library.name;
            _libraryDescriptionController.text = library.description ?? '';
            _libraryPathController.text = library.libraryPath ?? '';
            selectedType = library.libraryType;
          }

          return Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Library name
                const Text(
                  'Library Name',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: _libraryNameController,
                  placeholder: 'Enter library name',
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[600]!),
                  ),
                  style: const TextStyle(color: Colors.white),
                  placeholderStyle: TextStyle(color: Colors.grey[400]),
                ),

                const SizedBox(height: 16),

                // Library type
                const Text(
                  'Library Type',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[600]!),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<ModelLibraryLibraryTypeEnum?>(
                      value: selectedType,
                      isExpanded: true,
                      dropdownColor: Colors.grey[800],
                      style: const TextStyle(color: Colors.white),
                      items: [
                        const DropdownMenuItem<ModelLibraryLibraryTypeEnum?>(
                          value: null,
                          child: Text('Select type'),
                        ),
                        ...ModelLibraryLibraryTypeEnum.values.map(
                          (type) =>
                              DropdownMenuItem<ModelLibraryLibraryTypeEnum?>(
                                value: type,
                                child: Text(_getLibraryTypeDisplayName(type)),
                              ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedType = value;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Description
                const Text(
                  'Description (Optional)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: _libraryDescriptionController,
                  placeholder: 'Enter description',
                  maxLines: 3,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[600]!),
                  ),
                  style: const TextStyle(color: Colors.white),
                  placeholderStyle: TextStyle(color: Colors.grey[400]),
                ),

                const SizedBox(height: 16),

                // Library path
                const Text(
                  'Library Path (Optional)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: _libraryPathController,
                  placeholder: 'Enter file system path',
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[600]!),
                  ),
                  style: const TextStyle(color: Colors.white),
                  placeholderStyle: TextStyle(color: Colors.grey[400]),
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
                      label: managementState.isLoading ? 'Saving...' : 'Save',
                      variant: DButtonVariant.primary,
                      size: DButtonSize.sm,
                      onTap: managementState.isLoading
                          ? null
                          : () async {
                              if (_libraryNameController.text.isNotEmpty) {
                                try {
                                  // Convert ModelLibraryLibraryTypeEnum to ApiV1LibraryPutRequestLibraryTypeEnum
                                  ApiV1LibraryPutRequestLibraryTypeEnum?
                                  apiLibraryType;
                                  if (selectedType != null) {
                                    apiLibraryType = _convertToApiLibraryType(
                                      selectedType!,
                                    );
                                  }

                                  final putRequest =
                                      ApiV1LibraryPutRequestBuilder()
                                        ..id = library.id
                                        ..name = _libraryNameController.text
                                        ..description =
                                            _libraryDescriptionController
                                                .text
                                                .isEmpty
                                            ? null
                                            : _libraryDescriptionController.text
                                        ..libraryPath =
                                            _libraryPathController.text.isEmpty
                                            ? null
                                            : _libraryPathController.text
                                        ..libraryType = apiLibraryType;

                                  await ref
                                      .read(libraryManagementProvider.notifier)
                                      .updateLibrary(putRequest.build());
                                  if (mounted) context.pop();
                                } catch (e) {
                                  // Error is handled by the provider
                                }
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

  String _getLibraryTypeDisplayName(ModelLibraryLibraryTypeEnum type) {
    if (type == ModelLibraryLibraryTypeEnum.MOVIE) return 'Movies';
    if (type == ModelLibraryLibraryTypeEnum.TV_SHOW) return 'TV Shows';
    if (type == ModelLibraryLibraryTypeEnum.MUSIC) return 'Music';
    if (type == ModelLibraryLibraryTypeEnum.COMIC) return 'Comics';
    return 'Unknown';
  }

  ApiV1LibraryPutRequestLibraryTypeEnum _convertToApiLibraryType(
    ModelLibraryLibraryTypeEnum type,
  ) {
    if (type == ModelLibraryLibraryTypeEnum.MOVIE) {
      return ApiV1LibraryPutRequestLibraryTypeEnum.MOVIE;
    }
    if (type == ModelLibraryLibraryTypeEnum.TV_SHOW) {
      return ApiV1LibraryPutRequestLibraryTypeEnum.TV_SHOW;
    }
    if (type == ModelLibraryLibraryTypeEnum.MUSIC) {
      return ApiV1LibraryPutRequestLibraryTypeEnum.MUSIC;
    }
    if (type == ModelLibraryLibraryTypeEnum.COMIC) {
      return ApiV1LibraryPutRequestLibraryTypeEnum.COMIC;
    }
    throw ArgumentError('Unknown library type: $type');
  }
}
