import 'failures.dart' as failures;

/// A sealed class representing the result of an operation that can either
/// succeed with data or fail with a Failure
sealed class Result<T> {
  const Result();

  /// Returns true if the result is a success
  bool get isSuccess => this is Success<T>;

  /// Returns true if the result is a failure
  bool get isFailure => this is ResultFailure<T>;

  /// Get the data if successful, null otherwise
  T? get dataOrNull => switch (this) {
    Success<T>(:final data) => data,
    ResultFailure<T>() => null,
  };

  /// Get the failure if failed, null otherwise
  failures.Failure? get failureOrNull => switch (this) {
    Success<T>() => null,
    ResultFailure<T>(:final failure) => failure,
  };

  /// Transform the data if successful
  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success<T>(:final data) => Success(transform(data)),
      ResultFailure<T>(:final failure) => ResultFailure(failure),
    };
  }

  /// Transform the data asynchronously if successful
  Future<Result<R>> mapAsync<R>(Future<R> Function(T data) transform) async {
    return switch (this) {
      Success<T>(:final data) => Success(await transform(data)),
      ResultFailure<T>(:final failure) => ResultFailure(failure),
    };
  }

  /// Handle success or failure
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(failures.Failure failure) onFailure,
  }) {
    return switch (this) {
      Success<T>(:final data) => onSuccess(data),
      ResultFailure<T>(:final failure) => onFailure(failure),
    };
  }
}

/// Represents a successful result with data
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

/// Represents a failed result with a failure
class ResultFailure<T> extends Result<T> {
  final failures.Failure failure;

  const ResultFailure(this.failure);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultFailure<T> &&
          runtimeType == other.runtimeType &&
          failure == other.failure;

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'ResultFailure($failure)';
}

/// Extension to convert Future Result to Result Future (not common, but useful helpers)
extension ResultFutureExtension<T> on Future<Result<T>> {
  /// Handle the result when it completes
  Future<R> foldAsync<R>({
    required R Function(T data) onSuccess,
    required R Function(failures.Failure failure) onFailure,
  }) async {
    final result = await this;
    return result.fold(onSuccess: onSuccess, onFailure: onFailure);
  }
}
