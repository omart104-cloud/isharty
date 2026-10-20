/// Base interface for all business logic Use Cases in Clean Architecture.
abstract class UseCase<T, Params> {
  Future<T> call(Params params);
}

/// Use case that completes synchronously without Future overhead when working with in-memory data.
abstract class SyncUseCase<T, Params> {
  T call(Params params);
}

/// Parameter class when a UseCase does not take any arguments.
class NoParams {
  const NoParams();
}
