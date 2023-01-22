import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/failuer.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
