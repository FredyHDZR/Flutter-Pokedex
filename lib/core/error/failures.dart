abstract class Failure {
  Failure({required this.message});
  final String message;
}

class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

class CacheFailure extends Failure {
  CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message});
}

class NotFoundFailure extends Failure {
  NotFoundFailure({required super.message});
}
