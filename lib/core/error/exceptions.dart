abstract class AppException implements Exception {
  AppException({required this.message});
  final String message;
}

class ServerException extends AppException {
  ServerException({required super.message});
}

class CacheException extends AppException {
  CacheException({required super.message});
}

class NetworkException extends AppException {
  NetworkException({required super.message});
}

class NotFoundException extends AppException {
  NotFoundException({required super.message});
}

class ValidationException extends AppException {
  ValidationException({required super.message});
}
