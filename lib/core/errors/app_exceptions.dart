import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable implements Exception {
  final String message;
  final int? code;
  
  const AppException(this.message, {this.code});
  
  @override
  List<Object?> get props => [message, code];
  
  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

class ServerException extends AppException {
  const ServerException(super.message, {super.code});
}

class AuthenticationException extends AppException {
  const AuthenticationException(super.message, {super.code});
}

class AuthorizationException extends AppException {
  const AuthorizationException(super.message, {super.code});
}

class ValidationException extends AppException {
  const ValidationException(super.message, {super.code});
}

class CacheException extends AppException {
  const CacheException(super.message, {super.code});
}

class UnknownException extends AppException {
  const UnknownException(super.message, {super.code});
}

