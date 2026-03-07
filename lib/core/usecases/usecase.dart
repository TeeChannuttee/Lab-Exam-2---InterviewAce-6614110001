import 'package:dartz/dartz.dart';
import 'package:interview_ace/core/error/failures.dart';

/// Base UseCase class — every use case returns Either<Failure, Type>
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// For use cases that don't need parameters
class NoParams {
  const NoParams();
}
