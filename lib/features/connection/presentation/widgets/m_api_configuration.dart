// Dart
import 'dart:async';

// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';
import 'package:dester/core/widgets/d_icon.dart';
import 'package:dester/core/widgets/d_input.dart';
import 'package:dester/core/widgets/form_actions.dart';
import 'package:dester/core/widgets/m_base_modal.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

// Features
import 'package:dester/features/connection/connection_feature.dart';
import 'package:dester/features/connection/domain/entities/api_configuration.dart';
import 'package:dester/features/connection/domain/entities/api_health.dart';

/// Callback type for API configuration save with health status
typedef OnApiConfigSave =
    void Function(String url, String label, {bool isHealthy});

/// Modal for adding/editing API configurations
class ApiConfigurationModal extends StatefulWidget {
  final ApiConfiguration? initialConfig;
  final OnApiConfigSave onSave;

  const ApiConfigurationModal({
    super.key,
    this.initialConfig,
    required this.onSave,
  });

  static void show(
    BuildContext context, {
    ApiConfiguration? initialConfig,
    required OnApiConfigSave onSave,
  }) {
    BaseModal.show(
      context,
      title: initialConfig != null
          ? 'Edit API Configuration'
          : AppLocalization.settingsServersAddApi.tr(),
      content: ApiConfigurationModal(
        initialConfig: initialConfig,
        onSave: onSave,
      ),
    );
  }

  @override
  State<ApiConfigurationModal> createState() => _ApiConfigurationModalState();
}

class _ApiConfigurationModalState extends State<ApiConfigurationModal> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isSaving = false;
  ApiHealthStatus _healthStatus = ApiHealthStatus.idle;
  String? _healthError;
  late final _checkApiHealth = ConnectionFeature.createCheckApiHealth();

  @override
  void initState() {
    super.initState();
    // Check health once if we have an initial URL
    if (widget.initialConfig?.url != null) {
      _checkHealth();
    }
  }

  Future<void> _checkHealth() async {
    // Get URL from form or initial config
    final formState = _formKey.currentState;
    String? url;

    if (formState != null) {
      formState.save();
      url = (formState.value['url'] as String?)?.trim();
    } else {
      url = widget.initialConfig?.url;
    }

    if (url == null || url.isEmpty) {
      setState(() {
        _healthStatus = ApiHealthStatus.idle;
        _healthError = null;
      });
      return;
    }

    setState(() {
      _healthStatus = ApiHealthStatus.checking;
      _healthError = null;
    });

    final result = await _checkApiHealth(url);

    if (mounted) {
      setState(() {
        _healthStatus = result.status;
        _healthError = result.errorMessage;
      });
    }
  }

  void _onUrlChanged(String? value) {
    // Check health when URL changes
    if (value != null && value.trim().isNotEmpty) {
      _checkHealth();
    } else {
      setState(() {
        _healthStatus = ApiHealthStatus.idle;
        _healthError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DInput(
                name: 'label',
                initialValue: widget.initialConfig?.label,
                label: AppLocalization.settingsServersApiLabel.tr(),
                hintText: AppLocalization.settingsServersEnterApiLabel.tr(),
                leadingIcon: DIconName.tag,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Label is required';
                  }
                  return null;
                },
              ),
              AppConstants.spacingY(AppConstants.spacingMd),
              FormBuilderTextField(
                name: 'url',
                initialValue: widget.initialConfig?.url,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                onChanged: _onUrlChanged,
                style: AppTypography.bodyMedium(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  labelText: AppLocalization.settingsServersApiUrl.tr(),
                  hintText: AppLocalization.settingsServersEnterApiUrl.tr(),
                  labelStyle: AppTypography.labelLarge(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  hintStyle: AppTypography.bodyMedium(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppConstants.spacing16,
                    vertical: AppConstants.spacing12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                    borderSide: const BorderSide(color: Colors.white, width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                    borderSide: const BorderSide(
                      color: AppConstants.dangerColor,
                      width: 1,
                    ),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(
                      left: AppConstants.spacing16,
                      right: AppConstants.spacing8,
                    ),
                    child: DIcon(
                      icon: DIconName.link2,
                      size: AppConstants.iconSizeMd,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'URL is required';
                  }
                  try {
                    final uri = Uri.parse(value.trim());
                    if (!uri.hasScheme) {
                      return 'Invalid URL format: missing scheme (http:// or https://)';
                    }
                    if (uri.host.isEmpty && !uri.hasAuthority) {
                      return 'Invalid URL format: missing host';
                    }
                  } catch (e) {
                    return 'Invalid URL format';
                  }
                  return null;
                },
              ),
              AppConstants.spacingY(AppConstants.spacingMd),
              _buildHealthStatusWidget(context),
            ],
          ),
        ),
        FormActions(
          isSaving: _isSaving,
          onSave: () => _handleSave(context),
          saveLabel: _healthStatus == ApiHealthStatus.unhealthy
              ? 'Save Anyway'
              : null,
        ),
      ],
    );
  }

  Widget _buildHealthStatusWidget(BuildContext context) {
    final Color statusColor;
    final IconData statusIcon;
    final String statusText;

    switch (_healthStatus) {
      case ApiHealthStatus.idle:
        return const SizedBox.shrink();
      case ApiHealthStatus.checking:
        statusColor = Theme.of(context).colorScheme.primary;
        statusIcon = getIconDataFromDIconName(
          DIconName.refreshCw,
          strokeWidth: 2.0,
        );
        statusText = 'Checking connection...';
        break;
      case ApiHealthStatus.healthy:
        statusColor = AppConstants.successColor;
        statusIcon = getIconDataFromDIconName(
          DIconName.cloudCheck,
          strokeWidth: 2.0,
        );
        statusText = 'Server is reachable';
        break;
      case ApiHealthStatus.unhealthy:
        statusColor = AppConstants.dangerColor;
        statusIcon = getIconDataFromDIconName(
          DIconName.error,
          strokeWidth: 2.0,
        );
        statusText = _healthError ?? 'Server is unreachable';
        break;
    }

    return Container(
      padding: AppConstants.padding(AppConstants.spacing12),
      decoration: ShapeDecoration(
        color: statusColor.withValues(alpha: 0.1),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
      ),
      child: Row(
        children: [
          if (_healthStatus == ApiHealthStatus.checking)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            )
          else
            Icon(statusIcon, size: 20, color: statusColor),
          SizedBox(width: AppConstants.spacing8),
          Expanded(
            child: Text(
              statusText,
              style: AppTypography.bodySmall().copyWith(color: statusColor),
            ),
          ),
          if (_healthStatus != ApiHealthStatus.checking)
            GestureDetector(
              onTap: _checkHealth,
              child: Icon(
                getIconDataFromDIconName(DIconName.refreshCw, strokeWidth: 2.0),
                size: 16,
                color: statusColor,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleSave(BuildContext context) async {
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }

    final values = _formKey.currentState!.value;
    final url = (values['url'] as String?)?.trim() ?? '';
    final label = (values['label'] as String?)?.trim() ?? '';
    final isHealthy = _healthStatus.isHealthy;

    // If health status is unhealthy, show confirmation dialog
    if (_healthStatus.isUnhealthy) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Server Unreachable'),
          content: Text(
            'The server at "$url" is not responding. '
            'Do you still want to save this configuration?\n\n'
            'Note: It will not be set as the active server.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalization.cancel.tr()),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Save Anyway'),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        return;
      }
    }

    setState(() {
      _isSaving = true;
    });

    widget.onSave(url, label, isHealthy: isHealthy);

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
