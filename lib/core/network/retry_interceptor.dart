import 'package:dio/dio.dart';
import 'dart:io';
import '../constants/app_constants.dart';
import '../error/failures.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int retries;
  final List<Duration> retryDelays;

  RetryInterceptor({
    required this.dio,
    this.retries = AppConstants.maxRetries,
    List<Duration>? retryDelays,
  }) : retryDelays = retryDelays ??
            [
              Duration(seconds: 1),
              Duration(seconds: 2),
              Duration(seconds: 3),
            ];

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final retryCount = options.extra['retryCount'] ?? 0;

    if (retryCount < retries &&
        _shouldRetry(err) &&
        retryCount < retryDelays.length) {
      await Future.delayed(retryDelays[retryCount]);

      options.extra['retryCount'] = retryCount + 1;

      try {
        final response = await dio.fetch(options);
        return handler.resolve(response);
      } catch (e) {
        if (e is DioException) {
          return handler.reject(e);
        }
      }
    }

    return handler.reject(err);
  }

  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        (error.type == DioExceptionType.unknown &&
            error.error is SocketException) ||
        (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500);
  }
}

