import 'dart:async';

import 'failures.dart' as failures;
import 'result.dart';

/// Extension to convert Future that might throw to Result
extension FutureResultExtension<T> on Future<T> {
  /// Convert a Future that might throw to a Future Result
  Future<Result<T>> toResult() async {
    try {
      final data = await this;
      return Success(data);
    } on failures.Failure catch (failure) {
      return ResultFailure(failure);
    } catch (e) {
      return ResultFailure(failures.UnknownFailure(e.toString()));
    }
  }

  /// Convert a Future that might throw to a Future Result with custom error handling
  Future<Result<T>> toResultWithMapper(
    failures.Failure Function(Object error) errorMapper,
  ) async {
    try {
      final data = await this;
      return Success(data);
    } on failures.Failure catch (failure) {
      return ResultFailure(failure);
    } catch (e) {
      return ResultFailure(errorMapper(e));
    }
  }
}

/// Extension to convert Result to nullable for easier null-safe handling
extension ResultNullableExtension<T> on Result<T> {
  /// Get data or return null if failure
  T? get orNull => dataOrNull;

  /// Get data or throw if failure
  T get orThrow {
    return switch (this) {
      Success<T>(:final data) => data,
      ResultFailure<T>(:final failure) => throw failure,
    };
  }
}

/// Extension to add async map functionality to Result
extension ResultAsyncExtension<T> on Result<T> {
  /// Map success value asynchronously, preserving failure
  Future<Result<R>> mapAsync<R>(Future<R> Function(T data) transform) async {
    return switch (this) {
      Success<T>(:final data) => Success(await transform(data)),
      ResultFailure<T>(:final failure) => ResultFailure(failure),
    };
  }
}
