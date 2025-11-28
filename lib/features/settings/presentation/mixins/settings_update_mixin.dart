// External packages
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/errors/errors.dart';

/// Mixin that provides unified settings update functionality with:
/// - Immediate API calls (no debouncing since we have local copy)
/// - Throttled invalidations
/// - Per-field saving state tracking
/// - Optimistic updates
/// - Error handling
mixin SettingsUpdateMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  // Throttling
  DateTime? _lastInvalidationTime;
  static const Duration invalidationThrottle = Duration(seconds: 3);

  // Per-field saving state
  final Set<String> _savingFields = {};
  final Set<String> _pendingFields = {};

  /// Check if a specific field is currently being saved
  bool isFieldSaving(String fieldName) {
    return _savingFields.contains(fieldName);
  }

  /// Check if any field is currently being saved
  bool get isAnyFieldSaving => _savingFields.isNotEmpty;

  /// Get all fields that are currently being saved
  Set<String> get savingFields => Set.unmodifiable(_savingFields);

  /// Throttled invalidation to prevent too many API calls
  void throttledInvalidate(dynamic provider) {
    final now = DateTime.now();
    if (_lastInvalidationTime == null ||
        now.difference(_lastInvalidationTime!) >= invalidationThrottle) {
      _lastInvalidationTime = now;
      ref.invalidate(provider);
    }
  }

  /// Update settings with optimistic updates (no debouncing since we have local copy)
  ///
  /// [fieldName] - Unique identifier for the field being updated
  /// [updateFn] - Function that performs the API update and returns Result
  /// [optimisticUpdate] - Optional callback to update local state optimistically before API call
  /// [onSuccess] - Optional callback on successful update
  /// [onFailure] - Optional callback on failed update
  /// [skipInvalidationOnSuccess] - Whether to skip provider invalidation on success (default: true)
  /// [providerToInvalidate] - Provider to invalidate on failure or if skipInvalidationOnSuccess is false
  Future<void> debouncedUpdateSettings({
    required String fieldName,
    required Future<Result<void>> Function() updateFn,
    void Function()? optimisticUpdate,
    Duration?
    debounceDuration, // Deprecated - kept for API compatibility but ignored
    void Function()? onSuccess,
    void Function(String message)? onFailure,
    bool skipInvalidationOnSuccess = true,
    dynamic providerToInvalidate,
  }) async {
    // Prevent duplicate updates for the same field
    if (_savingFields.contains(fieldName)) return;

    // Batch all state updates into a single setState call to prevent multiple rebuilds
    setState(() {
      // Apply optimistic update if provided
      if (optimisticUpdate != null) {
        optimisticUpdate();
      }
      // Mark field as saving
      _savingFields.add(fieldName);
      _pendingFields.add(fieldName);
    });

    // Perform update immediately (no debouncing since we have local copy)
    final fieldsToClear = Set<String>.from(_pendingFields);
    _pendingFields.clear();

    try {
      final result = await updateFn();

      result.fold(
        onSuccess: (_) {
          if (!mounted) return;
          setState(() {
            _savingFields.removeAll(fieldsToClear);
          });
          // Don't invalidate on success by default - optimistic update is sufficient
          if (!skipInvalidationOnSuccess && providerToInvalidate != null) {
            throttledInvalidate(providerToInvalidate);
          }
          onSuccess?.call();
        },
        onFailure: (failure) {
          if (!mounted) return;
          setState(() {
            _savingFields.removeAll(fieldsToClear);
          });
          // On failure, invalidate to get correct server state
          if (providerToInvalidate != null) {
            throttledInvalidate(providerToInvalidate);
          }
          final message = failure.message;
          onFailure?.call(message);
          if (onFailure == null && mounted) {
            // Default error handling if no custom handler
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppConstants.dangerColor,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _savingFields.removeAll(fieldsToClear);
      });
      // On error, invalidate to get correct server state
      if (providerToInvalidate != null) {
        throttledInvalidate(providerToInvalidate);
      }
      final errorMessage = error.toString();
      onFailure?.call(errorMessage);
      if (onFailure == null && mounted) {
        // Default error handling if no custom handler
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppConstants.dangerColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Immediate update without debouncing (for actions like reset)
  ///
  /// [fieldName] - Unique identifier for the field being updated
  /// [updateFn] - Function that creates the updated settings object
  /// [updateSettings] - The UpdateSettings use case
  /// [onSuccess] - Optional callback on successful update
  /// [onFailure] - Optional callback on failed update
  /// [providerToInvalidate] - Provider to invalidate after update
  Future<void> immediateUpdateSettings({
    required String fieldName,
    required Future<Result<void>> Function() updateFn,
    void Function()? onSuccess,
    void Function(String message)? onFailure,
    dynamic providerToInvalidate,
  }) async {
    // Prevent duplicate updates for the same field
    if (_savingFields.contains(fieldName)) return;

    setState(() {
      _savingFields.add(fieldName);
    });

    try {
      final result = await updateFn();

      result.fold(
        onSuccess: (_) {
          if (!mounted) return;
          setState(() {
            _savingFields.remove(fieldName);
          });
          // Invalidate to sync with server after immediate update
          if (providerToInvalidate != null) {
            throttledInvalidate(providerToInvalidate);
          }
          onSuccess?.call();
        },
        onFailure: (failure) {
          if (!mounted) return;
          setState(() {
            _savingFields.remove(fieldName);
          });
          // On failure, invalidate to get correct server state
          if (providerToInvalidate != null) {
            throttledInvalidate(providerToInvalidate);
          }
          final message = failure.message;
          onFailure?.call(message);
          if (onFailure == null && mounted) {
            // Default error handling if no custom handler
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppConstants.dangerColor,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _savingFields.remove(fieldName);
      });
      // On error, invalidate to get correct server state
      if (providerToInvalidate != null) {
        throttledInvalidate(providerToInvalidate);
      }
      final errorMessage = error.toString();
      onFailure?.call(errorMessage);
      if (onFailure == null && mounted) {
        // Default error handling if no custom handler
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppConstants.dangerColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
