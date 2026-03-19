import 'package:chat_with_me_now/app.dart';
import 'package:chat_with_me_now/core/helpers/app_respnsive.dart';
import 'package:chat_with_me_now/firebase_options.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_with_me_now/config/env/env_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // OTP Settings
  EmailOTP.config(
    appName: EnvConfig.appName,
    otpLength: EnvConfig.otpLength,
    otpType: OTPType.numeric,
    emailTheme: EmailTheme.v3,
  );
  // SMTP Server Settings

  EmailOTP.setSMTP(
    host: EnvConfig.smtpHost,
    emailPort: EmailPort.port587,
    secureType: SecureType.tls,
    username: EnvConfig.smtpUsername,
    password: EnvConfig.smtpPassword,
  );
  runApp(AppResponsive(width: 411.42857, child: const ChatApp()));
}
