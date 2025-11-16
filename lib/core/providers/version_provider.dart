import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dester/app/providers.dart';
import 'package:dester/core/config/api_config.dart';
import 'package:dester/core/utils/version_checker.dart';
import 'package:dio/dio.dart';

/// Model for version information
class VersionInfo {
  final String clientVersion;
  final String? apiVersion;
  final bool? isCompatible;
  final String? message;

  VersionInfo({
    required this.clientVersion,
    this.apiVersion,
    this.isCompatible,
    this.message,
  });

  VersionInfo copyWith({
    String? clientVersion,
    String? apiVersion,
    bool? isCompatible,
    String? message,
  }) {
    return VersionInfo(
      clientVersion: clientVersion ?? this.clientVersion,
      apiVersion: apiVersion ?? this.apiVersion,
      isCompatible: isCompatible ?? this.isCompatible,
      message: message ?? this.message,
    );
  }
}

/// Notifier for managing version information
class VersionInfoNotifier extends Notifier<VersionInfo> {
  @override
  VersionInfo build() {
    return VersionInfo(clientVersion: ApiConfig.clientVersion);
  }

  /// Check version compatibility by calling the health endpoint
  Future<void> checkVersionCompatibility() async {
    try {
      final client = ref.read(openapiClientProvider);
      final healthApi = client.getHealthApi();

      // Make health check call - version will be checked by the interceptor
      await healthApi.healthGet();

      // The health response will trigger the Dio interceptor which will
      // update the version info from the response headers

      // If no exception was thrown, assume compatible
      // The actual version info will be updated by the interceptor
      state = VersionInfo(
        clientVersion: ApiConfig.clientVersion,
        apiVersion: null, // Will be populated from headers via interceptor
        isCompatible: true,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 426) {
        // Version mismatch
        final apiVersion = e.response?.data['data']?['apiVersion'] as String?;
        state = VersionInfo(
          clientVersion: ApiConfig.clientVersion,
          apiVersion: apiVersion,
          isCompatible: false,
          message:
              e.response?.data['message'] as String? ??
              'Version mismatch. Please update your app.',
        );
      } else {
        // Other error
        state = VersionInfo(
          clientVersion: ApiConfig.clientVersion,
          message: 'Failed to check version: ${e.message}',
        );
      }
    } catch (e) {
      state = VersionInfo(
        clientVersion: ApiConfig.clientVersion,
        message: 'Failed to check version: $e',
      );
    }
  }

  /// Update the API version from response headers
  void updateApiVersion(String apiVersion) {
    final isCompatible = VersionChecker.isVersionCompatible(
      ApiConfig.clientVersion,
      apiVersion,
    );

    state = state.copyWith(
      apiVersion: apiVersion,
      isCompatible: isCompatible,
      message: isCompatible
          ? null
          : VersionChecker.getVersionMismatchMessage(
              ApiConfig.clientVersion,
              apiVersion,
            ),
    );
  }
}

/// Provider for version information
final versionInfoProvider = NotifierProvider<VersionInfoNotifier, VersionInfo>(
  () => VersionInfoNotifier(),
);
