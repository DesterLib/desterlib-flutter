import 'package:flutter_test/flutter_test.dart';
import 'package:dester/core/errors/error_handlers.dart';
import 'package:dester/core/errors/failures.dart';
import 'package:dester/core/network/api_exception.dart';

void main() {
  group('ApiExceptionToFailure Extension', () {
    test('NetworkException converts to NetworkFailure', () {
      // Arrange
      const exception = NetworkException('Connection failed');

      // Act
      final failure = exception.toFailure();

      // Assert
      expect(failure, isA<NetworkFailure>());
      expect(failure.message, 'Connection failed');
    });

    test('BadRequestException converts to ValidationFailure', () {
      // Arrange
      const exception = BadRequestException('Invalid input');

      // Act
      final failure = exception.toFailure();

      // Assert
      expect(failure, isA<ValidationFailure>());
      expect(failure.message, 'Invalid input');
    });

    test('UnauthorizedException converts to AuthFailure', () {
      // Arrange
      const exception = UnauthorizedException('Unauthorized access');

      // Act
      final failure = exception.toFailure();

      // Assert
      expect(failure, isA<AuthFailure>());
      expect(failure.message, 'Unauthorized access');
    });

    test('ForbiddenException converts to AuthFailure', () {
      // Arrange
      const exception = ForbiddenException('Access forbidden');

      // Act
      final failure = exception.toFailure();

      // Assert
      expect(failure, isA<AuthFailure>());
      expect(failure.message, 'Access forbidden');
    });

    test('NotFoundException converts to NotFoundFailure', () {
      // Arrange
      const exception = NotFoundException('Resource not found');

      // Act
      final failure = exception.toFailure();

      // Assert
      expect(failure, isA<NotFoundFailure>());
      expect(failure.message, 'Resource not found');
    });

    test('ServerException converts to ServerFailure', () {
      // Arrange
      const exception = ServerException('Internal server error');

      // Act
      final failure = exception.toFailure();

      // Assert
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'Internal server error');
    });

    test('CancelledException converts to NetworkFailure', () {
      // Arrange
      const exception = CancelledException('Request cancelled');

      // Act
      final failure = exception.toFailure();

      // Assert
      expect(failure, isA<NetworkFailure>());
      expect(failure.message, 'Request cancelled');
    });

    test('UnknownException converts to ServerFailure', () {
      // Arrange
      const exception = UnknownException('Unknown error occurred');

      // Act
      final failure = exception.toFailure();

      // Assert
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'Unknown error occurred');
    });

    test('preserves status code information', () {
      // Arrange
      const exception = ServerException('Server error', statusCode: 500);

      // Act
      final failure = exception.toFailure();

      // Assert
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'Server error');
      expect(exception.statusCode, 500);
    });

    test('handles exception with additional data', () {
      // Arrange
      const exception = BadRequestException(
        'Validation failed',
        data: {'field': 'email', 'error': 'invalid format'},
      );

      // Act
      final failure = exception.toFailure();

      // Assert
      expect(failure, isA<ValidationFailure>());
      expect(failure.message, 'Validation failed');
      expect(exception.data, isNotNull);
      expect(exception.data['field'], 'email');
    });
  });
}
