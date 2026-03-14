import 'package:chat_with_me_now/features/auth/views/account_view.dart';
import 'package:chat_with_me_now/features/chat/views/home_view.dart';
import 'package:chat_with_me_now/features/auth/views/register_view.dart';
import 'package:chat_with_me_now/features/auth/views/sign_in_view.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String signIn = 'SignIn';
  static const String register = 'RegisterView';
  static const String home = 'HomeView';
  static const String account = 'AccountView';

  static Map<String, WidgetBuilder> get routes => {
    signIn: (context) => SignIn(),
    register: (context) => const RegisterView(),
    home: (context) => HomeView(),
    account: (context) => const AccountView(),
  };

  static String initialRoute(bool isLoggedIn) {
    return isLoggedIn ? home : signIn;
  }
}
