/// Failure classes for dartz Either pattern error handling

/// Base Failure class using dartz Either pattern
abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  String toString() => 'Failure(message: $message, statusCode: $statusCode)';
}

/// Server/API failure (network issues, API errors)
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

/// Cache failure (Hive/SharedPreferences errors)
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Database failure (Drift/SQLite errors)
class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message});
}

/// ML Kit failure (camera, text recognition, face detection errors)
class MLKitFailure extends Failure {
  const MLKitFailure({required super.message});
}

/// Validation failure (form validation, business rules)
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}
