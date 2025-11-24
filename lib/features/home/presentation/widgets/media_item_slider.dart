// External packages
import 'package:flutter/material.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';

/// A reusable slider widget for displaying media items horizontally
class MediaItemSlider<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final bool isLoading;
  final String? error;
  final String emptyMessage;
  final VoidCallback onRetry;
  final String retryLabel;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  const MediaItemSlider({
    super.key,
    required this.title,
    required this.items,
    required this.isLoading,
    this.error,
    required this.emptyMessage,
    required this.onRetry,
    required this.retryLabel,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppConstants.padding(AppConstants.spacing16),
          child: Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
        if (isLoading)
          const SizedBox(
            height: 280,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (error != null)
          SizedBox(
            height: 280,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(error!, style: const TextStyle(color: Colors.red)),
                  AppConstants.spacingY(AppConstants.spacing8),
                  ElevatedButton(onPressed: onRetry, child: Text(retryLabel)),
                ],
              ),
            ),
          )
        else if (items.isEmpty)
          SizedBox(height: 280, child: Center(child: Text(emptyMessage)))
        else
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Padding(
                  padding: AppConstants.paddingOnly(
                    left: index == 0
                        ? AppConstants.spacing16
                        : AppConstants.spacing0,
                    right: index == items.length - 1
                        ? AppConstants.spacing16
                        : AppConstants.spacing12,
                  ),
                  child: itemBuilder(context, item, index),
                );
              },
            ),
          ),
      ],
    );
  }
}
