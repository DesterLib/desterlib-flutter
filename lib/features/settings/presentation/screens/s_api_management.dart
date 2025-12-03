// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// App
import 'package:dester/app/localization/app_localization.dart';
import 'package:dester/app/providers/connection_guard_provider.dart';

// Core
import 'package:dester/core/widgets/d_app_bar.dart';
import 'package:dester/core/widgets/d_icon.dart';
import 'package:dester/core/widgets/d_icon_button.dart';

// Features
import 'package:dester/features/connection/presentation/widgets/m_api_configuration.dart';
import 'package:dester/features/settings/presentation/widgets/api_list_widget.dart';

class ApiManagementScreen extends ConsumerWidget {
  const ApiManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DAppBar(
            title: AppLocalization.settingsServersApisTab.tr(),
            isCompact: true,
            actions: [
              Tooltip(
                message: AppLocalization.settingsServersAddApi.tr(),
                child: DIconButton(
                  icon: DIconName.plus,
                  variant: DIconButtonVariant.plain,
                  onPressed: () => _showAddApiModal(context, ref),
                ),
              ),
            ],
          ),
          const ApiConfigurationSlivers(
            options: ApiConfigurationContentOptions.apiManagement(),
          ),
        ],
      ),
    );
  }

  void _showAddApiModal(BuildContext context, WidgetRef ref) {
    ApiConfigurationModal.show(
      context,
      onSave: (url, label, {bool isHealthy = false}) {
        // Only set as active if health check passed
        ref
            .read(connectionGuardProvider.notifier)
            .addApiConfiguration(url, label, setAsActive: isHealthy);
      },
    );
  }
}
