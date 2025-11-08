import 'package:flutter/material.dart';
import 'package:dester/shared/widgets/modals/settings_modal_wrapper.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/shared/widgets/ui/loading_indicator.dart';
import 'package:dester/app/theme/theme.dart';

/// Configuration-based modal/drawer system
/// Reduces code duplication by using a declarative config approach

/// Main configuration for a modal/drawer
class ModalConfig {
  final String title;
  final List<ModalBannerConfig>? banners;
  final List<ModalFieldConfig> fields;
  final List<ModalSectionConfig>? customSections;
  final List<ModalActionConfig> actions;
  final Future<Map<String, dynamic>> Function()? asyncInit;
  final bool isDismissible;
  final bool showCloseButton;
  final double? maxWidth;
  final bool useFullscreenOnMobile;

  const ModalConfig({
    required this.title,
    this.banners,
    required this.fields,
    this.customSections,
    required this.actions,
    this.asyncInit,
    this.isDismissible = true,
    this.showCloseButton = true,
    this.maxWidth,
    this.useFullscreenOnMobile = false,
  });
}

/// Configuration for banner/alert messages
class ModalBannerConfig {
  final String message;
  final SettingsModalBannerType type;
  final IconData? icon;
  final bool Function()? shouldShow; // Optional condition

  const ModalBannerConfig({
    required this.message,
    this.type = SettingsModalBannerType.info,
    this.icon,
    this.shouldShow,
  });
}

/// Configuration for custom sections (non-field widgets)
class ModalSectionConfig {
  final Widget Function(
    BuildContext context,
    Map<String, dynamic> state,
    void Function(Map<String, dynamic>) updateState,
  )
  builder;
  final int position;

  const ModalSectionConfig({required this.builder, this.position = 0});
}

/// Configuration for input fields
class ModalFieldConfig {
  final String key;
  final String? label;
  final String? hintText;
  final String? description;
  final bool obscureText;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixWidget;
  final Widget Function(
    BuildContext context,
    String? value,
    void Function(String?) onChanged,
    Map<String, dynamic> state,
  )?
  customBuilder;

  const ModalFieldConfig({
    required this.key,
    this.label,
    this.hintText,
    this.description,
    this.obscureText = false,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
    this.suffixWidget,
    this.customBuilder,
  });
}

/// Configuration for action buttons
class ModalActionConfig {
  final String label;
  final IconData? icon;
  final DButtonVariant variant;
  final DButtonSize size;
  final Future<void> Function(
    Map<String, String> fieldValues,
    Map<String, dynamic> state,
    BuildContext context,
  )?
  onTap;
  final bool Function(
    Map<String, String> fieldValues,
    Map<String, dynamic> state,
  )?
  shouldShow;
  final String? Function(
    Map<String, String> fieldValues,
    Map<String, dynamic> state,
  )?
  labelBuilder;
  final IconData? Function(
    Map<String, String> fieldValues,
    Map<String, dynamic> state,
  )?
  iconBuilder;

  const ModalActionConfig({
    required this.label,
    this.icon,
    this.variant = DButtonVariant.primary,
    this.size = DButtonSize.sm,
    this.onTap,
    this.shouldShow,
    this.labelBuilder,
    this.iconBuilder,
  });
}

/// Shows a configurable modal that adapts to screen size
Future<T?> showConfigurableModal<T>({
  required BuildContext context,
  required ModalConfig config,
  Map<String, String>? initialValues,
}) {
  return showSettingsModal<T>(
    context: context,
    title: config.title,
    isDismissible: config.isDismissible,
    showCloseButton: config.showCloseButton,
    maxWidth: config.maxWidth,
    useFullscreenOnMobile: config.useFullscreenOnMobile,
    builder: (context) => _ConfigurableModalContent(
      config: config,
      initialValues: initialValues ?? {},
    ),
  );
}

/// Internal widget that builds the modal content from config
class _ConfigurableModalContent extends StatefulWidget {
  final ModalConfig config;
  final Map<String, String> initialValues;

  const _ConfigurableModalContent({
    required this.config,
    required this.initialValues,
  });

  @override
  State<_ConfigurableModalContent> createState() =>
      _ConfigurableModalContentState();
}

class _ConfigurableModalContentState extends State<_ConfigurableModalContent> {
  late Map<String, TextEditingController> _controllers;
  late Map<String, dynamic> _state;
  bool _isLoading = false;
  bool _isInitializing = false;
  String? _errorMessage;
  final Map<String, String?> _fieldErrors = {};

  @override
  void initState() {
    super.initState();

    _controllers = {
      for (final field in widget.config.fields)
        field.key: TextEditingController(
          text: widget.initialValues[field.key] ?? '',
        ),
    };

    _state = {};

    if (widget.config.asyncInit != null) {
      _isInitializing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          final initData = await widget.config.asyncInit!();
          if (mounted) {
            setState(() {
              _state = initData;
              for (final field in widget.config.fields) {
                if (initData.containsKey(field.key)) {
                  _controllers[field.key]?.text =
                      initData[field.key]?.toString() ?? '';
                }
              }
              _isInitializing = false;
            });
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              _errorMessage = 'Failed to load data: ${e.toString()}';
              _isInitializing = false;
            });
          }
        }
      });
    }
  }

  void _updateState(Map<String, dynamic> updates) {
    setState(() {
      _state.addAll(updates);
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Map<String, String> get _fieldValues {
    return {
      for (final entry in _controllers.entries) entry.key: entry.value.text,
    };
  }

  bool _validateFields() {
    bool isValid = true;
    _fieldErrors.clear();

    for (final field in widget.config.fields) {
      final value = _controllers[field.key]?.text;
      if (field.validator != null) {
        final error = field.validator!(value);
        if (error != null) {
          _fieldErrors[field.key] = error;
          isValid = false;
        }
      }
    }

    setState(() {});
    return isValid;
  }

  Future<void> _handleAction(ModalActionConfig action) async {
    if (action.onTap == null) return;

    setState(() {
      _errorMessage = null;
    });

    if (!_validateFields()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await action.onTap!(_fieldValues, _state, context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: DLoadingIndicator(),
        ),
      );
    }

    final allSections = <Widget>[];

    if (widget.config.banners != null) {
      allSections.addAll(
        widget.config.banners!
            .where((banner) => banner.shouldShow?.call() ?? true)
            .map(
              (banner) => SettingsModalBanner(
                message: banner.message,
                type: banner.type,
                icon: banner.icon,
              ),
            ),
      );
    }

    if (_errorMessage != null) {
      allSections.add(
        SettingsModalBanner(
          message: _errorMessage!,
          type: SettingsModalBannerType.error,
        ),
      );
    }

    final customSectionsByPosition = <int, List<Widget>>{};
    if (widget.config.customSections != null) {
      for (final section in widget.config.customSections!) {
        customSectionsByPosition.putIfAbsent(section.position, () => []);
        customSectionsByPosition[section.position]!.add(
          section.builder(context, _state, _updateState),
        );
      }
    }

    if (customSectionsByPosition.containsKey(0)) {
      allSections.addAll(customSectionsByPosition[0]!);
    }

    for (var i = 0; i < widget.config.fields.length; i++) {
      final field = widget.config.fields[i];
      final controller = _controllers[field.key]!;
      final error = _fieldErrors[field.key];

      if (field.customBuilder != null) {
        allSections.add(
          SettingsModalSection(
            label: field.label,
            description: field.description,
            child: field.customBuilder!(context, controller.text, (value) {
              setState(() {
                controller.text = value ?? '';
              });
            }, _state),
          ),
        );
      } else {
        allSections.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsModalTextField(
                controller: controller,
                label: field.label,
                hintText: field.hintText,
                maxLines: field.maxLines,
                keyboardType: field.keyboardType,
                enabled: !_isLoading,
              ),
              if (error != null) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    error,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
              if (field.suffixWidget != null) ...[
                const SizedBox(height: 8),
                field.suffixWidget!,
              ],
            ],
          ),
        );
      }

      if (customSectionsByPosition.containsKey(i + 1)) {
        allSections.addAll(customSectionsByPosition[i + 1]!);
      }
    }

    allSections.add(
      SettingsModalActions(
        actions: widget.config.actions
            .where(
              (action) => action.shouldShow?.call(_fieldValues, _state) ?? true,
            )
            .map((action) {
              final label =
                  action.labelBuilder?.call(_fieldValues, _state) ??
                  action.label;
              final icon =
                  action.iconBuilder?.call(_fieldValues, _state) ?? action.icon;

              return DButton(
                label: _isLoading ? 'Loading...' : label,
                icon: icon,
                variant: action.variant,
                size: action.size,
                onTap: _isLoading ? null : () => _handleAction(action),
              );
            })
            .toList(),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: allSections,
    );
  }
}
