import 'package:flutter_pokedex/core/error/exceptions.dart';
import 'package:flutter_pokedex/core/error/failures.dart';

class FailureMapper {
  static Failure mapExceptionToFailure(Exception exception) {
    if (exception is ServerException) {
      return ServerFailure(message: exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(message: exception.message);
    } else if (exception is NetworkException) {
      return NetworkFailure(message: exception.message);
    } else if (exception is NotFoundException) {
      return NotFoundFailure(message: exception.message);
    } else {
      return ServerFailure(
        message: 'Error inesperado: ${exception.toString()}',
      );
    }
  }
}
