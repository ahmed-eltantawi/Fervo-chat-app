part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

// === Login States ===
final class LoginSuccess extends AuthState {}

final class LoginLoading extends AuthState {}

final class LoginFailure extends AuthState {}

// === Register States ===
final class RegisterInitial extends AuthState {}

final class RegisterSuccess extends AuthState {}

final class RegisterLoading extends AuthState {}

final class RegisterFailure extends AuthState {}

final class CheckBoxError extends AuthState {}

final class CheckBoxValid extends AuthState {}
