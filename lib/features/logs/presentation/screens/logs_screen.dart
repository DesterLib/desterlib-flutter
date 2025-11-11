import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dester/shared/widgets/ui/app_bar.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/shared/widgets/ui/badge.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:dester/core/providers/logs_provider.dart';
import 'package:dester/app/theme/theme.dart';
import '../widgets/log_item.dart';
import '../widgets/log_filter_bar.dart';
import '../modals/logs_modals.dart';

class LogsScreen extends ConsumerStatefulWidget {
  const LogsScreen({super.key});

  @override
  ConsumerState<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends ConsumerState<LogsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logsState = ref.watch(logsProvider);
    // Logs are already in descending order (newest first) from backend
    final logs = logsState.filteredLogs;

    // Responsive app bar height
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    final appBarHeight = isDesktop ? 80.0 : 120.0;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: DAppBar(
          title: 'API Logs',
          height: appBarHeight,
          maxWidthConstraint: 1400,
          actions: [
            // Refresh button
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: DButton(
                icon: PlatformIcons.refresh,
                variant: DButtonVariant.ghost,
                size: DButtonSize.sm,
                onTap: () async {
                  await ref.read(logsProvider.notifier).refreshLogs();
                },
              ),
            ),
            // Clear logs button
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: DButton(
                icon: PlatformIcons.delete,
                variant: DButtonVariant.ghost,
                size: DButtonSize.sm,
                onTap: logs.isEmpty
                    ? null
                    : () async {
                        await ClearLogsModal.show(context, ref);
                      },
              ),
            ),
            // Connection status badge
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: DBadge(
                label: logsState.isConnected ? 'Connected' : 'Disconnected',
                icon: logsState.isConnected
                    ? PlatformIcons.checkCircle
                    : PlatformIcons.errorCircle,
                backgroundColor: logsState.isConnected
                    ? Colors.green.withValues(alpha: 0.15)
                    : Colors.red.withValues(alpha: 0.15),
                textColor: logsState.isConnected ? Colors.green : Colors.red,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                children: [
                  AppSpacing.gapVerticalMD,
                  // Filter bar
                  LogFilterBar(
                    selectedLevel: logsState.levelFilter,
                    onLevelChanged: (level) {
                      ref.read(logsProvider.notifier).setLevelFilter(level);
                    },
                    totalCount: logsState.logs.length,
                    filteredCount: logs.length,
                  ),
                  AppSpacing.gapVerticalMD,
                  // Logs list - fills remaining space
                  Expanded(
                    child: logs.isEmpty
                        ? _buildEmptyState(logsState.isConnected)
                        : _buildLogsList(logs),
                  ),
                  AppSpacing.gapVerticalMD,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isConnected) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: ShapeDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
            ),
            child: Icon(
              isConnected ? PlatformIcons.code : PlatformIcons.errorCircle,
              size: 48,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
          AppSpacing.gapVerticalLG,
          Text(
            isConnected ? 'No logs yet' : 'Disconnected from API server',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
          AppSpacing.gapVerticalSM,
          Text(
            isConnected
                ? 'Logs will appear here in real-time'
                : 'Connect to the API server to view logs',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.5),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogsList(List logs) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ListView.separated(
          controller: _scrollController,
          padding: EdgeInsets.zero,
          itemCount: logs.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            thickness: 1,
            color: Colors.white.withValues(alpha: 0.08),
          ),
          itemBuilder: (context, index) {
            return LogItem(
              log: logs[index],
              onTap: () => LogDetailsModal.show(context, ref, logs[index]),
            );
          },
        ),
      ),
    );
  }
}
