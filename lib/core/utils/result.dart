import '../errors/app_exceptions.dart';

import '../errors/app_exceptions.dart';

sealed class Result<T> {
  const Result();
  
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  
  T? get dataOrNull => switch (this) {
    Success<T>(:final value) => value,
    Failure<T>() => null,
  };
  
  AppException? get errorOrNull => switch (this) {
    Success<T>() => null,
    Failure<T>(:final exception) => exception,
  };
  
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppException error) onFailure,
  }) {
    return switch (this) {
      Success<T>(:final value) => onSuccess(value),
      Failure<T>(:final exception) => onFailure(exception),
    };
  }
}

final class Success<T> extends Result<T> {
  final T value;
  
  const Success(this.value);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

final class Failure<T> extends Result<T> {
  final AppException exception;
  
  const Failure(this.exception);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          runtimeType == other.runtimeType &&
          exception == other.exception;

  @override
  int get hashCode => exception.hashCode;
}

