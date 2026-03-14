part of 'auth_bloc.dart';

sealed class AuthEvent {}

class LoginEvent extends AuthEvent {
  final BuildContext context;
  final String email;
  final String password;
  LoginEvent({
    required this.context,
    required this.email,
    required this.password,
  });
}

class GoogleLoginEvent extends AuthEvent {
  final BuildContext context;

  GoogleLoginEvent({required this.context});
}

class FacebookLoginEvent extends AuthEvent {
  final BuildContext context;
  FacebookLoginEvent({required this.context});
}

class RegisterEvent extends AuthEvent {
  final BuildContext context;
  final String? email;
  final String? userName;

  RegisterEvent({
    required this.context,
    required this.email,
    required this.userName,
  });
}
