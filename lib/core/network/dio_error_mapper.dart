import 'package:dio/dio.dart';
import 'package:story_craft/core/error/failures.dart';

Failure mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return NetworkFailure(message: e.message ?? 'Connection failed');
    case DioExceptionType.badResponse:
      final code = e.response?.statusCode;
      return ServerFailure(
        message: e.message ?? 'Server error',
        statusCode: code,
      );
    case DioExceptionType.cancel:
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      if (e.error is FormatException) {
        return const ServerFailure(message: 'Invalid response');
      }
      return UnknownFailure(message: e.message ?? 'Unknown error');
  }
}
