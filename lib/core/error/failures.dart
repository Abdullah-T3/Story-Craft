import 'package:fpdart/fpdart.dart';

/// Domain / application error surface. Map infrastructure exceptions here.
sealed class Failure implements Exception {
  const Failure({required this.message});

  final String message;

  @override
  String toString() => message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Network error'});
}

final class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error', this.statusCode});

  final int? statusCode;
}

final class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error'});
}

final class AuthFailure extends Failure {
  const AuthFailure({required super.message, this.code});

  final String? code;
}

final class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Unknown error'});
}

typedef AppResult<T> = Either<Failure, T>;
