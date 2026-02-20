import 'package:chat_with_me_now/Views/acount_view.dart';
import 'package:chat_with_me_now/Views/home_view.dart';
import 'package:chat_with_me_now/Views/sign_in_view.dart';
import 'package:chat_with_me_now/Views/register_view.dart';
import 'package:chat_with_me_now/firebase_options.dart';
import 'package:chat_with_me_now/theme/theme_probider.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //OTP Settings
  EmailOTP.config(
    appName: 'Fervo',
    otpLength: 4,
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
      child: ChatApp(),
      create: (context) => ThemeProvider(),
    ),
  );
}

class ChatApp extends StatelessWidget {
  ChatApp({super.key});
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,

      routes: {
        SignIn.id: (context) => SignIn(),
        RegisterView.id: (context) => RegisterView(),
        HomeView.id: (context) => HomeView(),
        AccountView.id: (context) => AccountView(),
      },
      initialRoute: user?.email == null ? SignIn.id : HomeView.id,
    );
  }
}
