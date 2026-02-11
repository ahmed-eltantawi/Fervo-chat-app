import 'package:chat_with_me_now/Views/home_view.dart';
import 'package:chat_with_me_now/Views/login_view.dart';
import 'package:chat_with_me_now/Views/register_view.dart';
import 'package:chat_with_me_now/firebase_options.dart';
import 'package:chat_with_me_now/theme/theme_probider.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //OTP Settings
  EmailOTP.config(
    appName: 'Fervo',
    otpLength: 5,
    otpType: OTPType.numeric,
    emailTheme: EmailTheme.v3,
  );

  //Server Settings
  EmailOTP.setSMTP(
    host: 'smtp.gmail.com',
    emailPort: EmailPort.port587,
    secureType: SecureType.tls,
    username: 'listen.me.127@gmail.com',
    password: 'wjtm lmre tdeo azot',
  );

  runApp(
    ChangeNotifierProvider(
      child: const ChatApp(),
      create: (context) => ThemeProvider(),
    ),
  );
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        // ChatView.id: (context) => ChatView(),
        LoginView.id: (context) => LoginView(),
        RegisterView.id: (context) => RegisterView(),
        HomeView.id: (context) => HomeView(),
      },

      initialRoute: LoginView.id,
      // home: otpView(email: 'ahmed@gmail.com'),
    );
  }
}
