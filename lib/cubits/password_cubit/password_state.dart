part of 'password_cubit.dart';

sealed class PasswordState {}

final class PasswordInitial extends PasswordState {}

final class ShowPassword extends PasswordState {}

final class HidePassword extends PasswordState {}
