import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_pokedex/core/constants/api_constants.dart';
import 'package:flutter_pokedex/core/constants/app_constants.dart';
import 'package:flutter_pokedex/core/error/failures.dart';
import 'package:flutter_pokedex/core/network/retry_interceptor.dart';

class DioClient {

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: AppConstants.networkTimeout,
        receiveTimeout: AppConstants.networkTimeout,
        sendTimeout: AppConstants.networkTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        followRedirects: true,
        maxRedirects: 5,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );

    _setupInterceptors();
  }
  late final Dio _dio;

  void _setupInterceptors() {
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          final failure = _mapDioErrorToFailure(error);
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: failure,
              response: error.response,
              type: error.type,
            ),
          );
        },
      ),
    );
  }

  Failure _mapDioErrorToFailure(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure(
          message: 'Tiempo de espera agotado. Verifica tu conexión.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 404) {
          return NotFoundFailure(message: 'Recurso no encontrado');
        } else if (statusCode == 500) {
          return ServerFailure(message: 'Error del servidor');
        } else {
          return ServerFailure(
            message: 'Error HTTP: $statusCode',
          );
        }

      case DioExceptionType.cancel:
        return NetworkFailure(message: 'Request cancelado');

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NetworkFailure(
            message: 'Sin conexión a internet',
          );
        }
        return NetworkFailure(
          message: 'Error de red desconocido: ${error.message}',
        );

      default:
        return NetworkFailure(message: 'Error de red: ${error.message}');
    }
  }

  Dio get dio => _dio;
}
