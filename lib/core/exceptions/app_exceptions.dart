class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  AppException({required this.message, this.statusCode, this.details});

  @override
  String toString() => 'AppException(statusCode: $statusCode, message: $message)';
}

class ServerException extends AppException {
  ServerException({required super.message, super.statusCode, super.details});
}

class UnauthorizedException extends AppException {
  UnauthorizedException({super.message = 'Session expired. Please log in again.', super.statusCode = 401});
}

class ForbiddenException extends AppException {
  ForbiddenException({super.message = 'You do not have permission to access this resource.', super.statusCode = 403});
}

class NotFoundException extends AppException {
  NotFoundException({super.message = 'The requested resource was not found.', super.statusCode = 404});
}

class NetworkException extends AppException {
  NetworkException({super.message = 'Network connection failed. Please verify your connection.'});
}

class TimeoutException extends AppException {
  TimeoutException({super.message = 'Request timed out. Please try again.'});
}

