import 'dart:async';

import 'package:chat_with_me_now/core/helpers/show_snack_bar.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';

abstract class OtpServices {
  static void _startComedownTimer({
    required int secondsRemaining,
    required Timer? timer,
  }) {
    secondsRemaining = 30;
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      secondsRemaining--;

      if (secondsRemaining == 0) {
        timer.cancel();
      }
    });
  }

  static void clearAllPins({
    required List<String> pins,
    required List<TextEditingController> controllers,
  }) {
    for (int i = 0; i < 4; i++) {
      pins[i] = '';
      controllers[i].clear();
    }
  }

  static Future<void> sendOtpCode({
    required String email,
    required BuildContext context,
    required Timer? timer,
    required int secondsRemaining,
  }) async {
    bool result = await EmailOTP.sendOTP(email: email);

    if (result) {
      showSnackBar(context, 'The OTP has been sent successfully');
      _startComedownTimer(timer: timer, secondsRemaining: secondsRemaining);
    } else {
      showSnackBar(context, 'Sending failed, try again');
    }
  }
}
