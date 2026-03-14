import 'package:chat_with_me_now/config/routes/app_routes.dart';
import 'package:chat_with_me_now/features/auth/bloc/auth_bloc.dart';
import 'package:chat_with_me_now/features/auth/cubit/password_cubit/password_cubit.dart';
import 'package:chat_with_me_now/features/chat/cubit/chat_cubit.dart';
import 'package:chat_with_me_now/config/theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc()),
          BlocProvider(create: (context) => PasswordCubit()),
          BlocProvider(create: (context) => ChatCubit()),
        ],
        child: Builder(
          builder: (context) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: Provider.of<ThemeProvider>(context).themeData,
              routes: AppRoutes.routes,
              initialRoute: AppRoutes.initialRoute(user?.email != null),
            );
          },
        ),
      ),
    );
  }
}
