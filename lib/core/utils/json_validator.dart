import 'package:flutter_pokedex/core/error/exceptions.dart';

class JsonValidator {
  static T? validateAndParse<T>(
    dynamic json,
    T Function(Map<String, dynamic>) fromJson,
    String fieldName,
  ) {
    if (json == null) {
      throw ValidationException(
        message: 'Campo $fieldName es requerido pero es null',
      );
    }

    if (json is! Map<String, dynamic>) {
      throw ValidationException(
        message: 'Campo $fieldName debe ser un objeto JSON',
      );
    }

    try {
      return fromJson(json);
    } catch (e) {
      throw ValidationException(
        message: 'Error al parsear $fieldName: $e',
      );
    }
  }

  static List<T> validateList<T>(
    dynamic json,
    T Function(dynamic) fromJson,
    String fieldName,
  ) {
    if (json == null) {
      return [];
    }

    if (json is! List) {
      throw ValidationException(
        message: 'Campo $fieldName debe ser una lista',
      );
    }

    try {
      return json.map((item) => fromJson(item)).toList();
    } catch (e) {
      throw ValidationException(
        message: 'Error al parsear lista $fieldName: $e',
      );
    }
  }

  static String validateString(dynamic json, String fieldName) {
    if (json == null) {
      throw ValidationException(
        message: 'Campo $fieldName es requerido',
      );
    }

    if (json is! String) {
      throw ValidationException(
        message: 'Campo $fieldName debe ser un String',
      );
    }

    return json;
  }

  static int validateInt(dynamic json, String fieldName) {
    if (json == null) {
      throw ValidationException(
        message: 'Campo $fieldName es requerido',
      );
    }

    if (json is int) {
      return json;
    }

    if (json is String) {
      final parsed = int.tryParse(json);
      if (parsed != null) return parsed;
    }

    throw ValidationException(
      message: 'Campo $fieldName debe ser un entero',
    );
  }
}
