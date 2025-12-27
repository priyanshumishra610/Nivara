import '../utils/result.dart';
import '../errors/app_exceptions.dart';

abstract class BaseRepository {
  Future<Result<T>> handleRepositoryCall<T>(
    Future<T> Function() call,
  ) async {
    try {
      final result = await call();
      return Success(result);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(UnknownException('Repository operation failed: $e'));
    }
  }
}

