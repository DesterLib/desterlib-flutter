/// Connection status enum
enum ConnectionStatus { connected, disconnected, checking, error }

/// Connection state entity
class ConnectionGuardState {
  final ConnectionStatus status;
  final String? errorMessage;
  final String? apiUrl;

  const ConnectionGuardState({
    required this.status,
    this.errorMessage,
    this.apiUrl,
  });

  ConnectionGuardState copyWith({
    ConnectionStatus? status,
    String? errorMessage,
    String? apiUrl,
    bool clearErrorMessage = false,
    bool clearApiUrl = false,
  }) {
    return ConnectionGuardState(
      status: status ?? this.status,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      apiUrl: clearApiUrl ? null : (apiUrl ?? this.apiUrl),
    );
  }
}
