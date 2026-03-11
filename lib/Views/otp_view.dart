import 'dart:async';

import 'package:chat_with_me_now/Widgets/custom_bottom.dart';
import 'package:chat_with_me_now/helper/extensions.dart';
import 'package:chat_with_me_now/helper/show_snack_bar.dart';
import 'package:chat_with_me_now/auth/register_function.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class OTPView extends StatefulWidget {
  const OTPView({
    super.key,
    required this.email,
    required this.password,
    required this.userName,
  });
  final String email;
  final String password;
  final String userName;

  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  List<String> pins = ['', '', '', ''];
  List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  bool isLoading = false;
  String image = 'assets/images/email sended.json';

  int _secondsRemaining = 0;
  Timer? _timer;

  bool get isComplete => pins.every((p) => p.isNotEmpty);

  @override
  void initState() {
    super.initState();
    sendOtpCode();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _startCooldownTimer() {
    _secondsRemaining = 30;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _secondsRemaining--;
      });
      if (_secondsRemaining == 0) {
        timer.cancel();
      }
    });
  }

  void _clearAllPins() {
    for (int i = 0; i < 4; i++) {
      pins[i] = '';
      controllers[i].clear();
    }
  }

  Future<void> sendOtpCode() async {
    bool result = await EmailOTP.sendOTP(email: widget.email);
    if (!mounted) return;

    if (result) {
      showSnackBar(context, 'The OTP has been sent successfully');
      _startCooldownTimer();
    } else {
      showSnackBar(context, 'Sending failed, try again');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 250,
                    child: LottieBuilder.asset(
                      image,
                      repeat: false,
                      key: ValueKey(image),
                    ),
                  ),
                  Text(
                    "Verify it's you",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "We've sent a 4-digit code to",
                    style: TextStyle(fontSize: 16),
                  ),

                  Text(
                    widget.email,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 50),
                  Form(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        4,
                        (index) => _CustomTextOtp(
                          controller: controllers[index],
                          onChanged: (value) {
                            setState(() {
                              pins[index] = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 70),
                  CustomBottom(
                    text: 'Verify',
                    onTap: () async {
                      if (!isComplete) {
                        setState(() {
                          image = 'assets/images/error x.json';
                        });
                        showSnackBar(context, 'Please enter all digits');
                        return;
                      }

                      setState(() {
                        isLoading = true;
                      });

                      String otp = pins.join();

                      if (EmailOTP.verifyOTP(otp: otp)) {
                        if (!mounted) return;
                        showSnackBar(context, 'OTP is correct');
                        await registerFunction(
                          context: context,
                          email: widget.email,
                          password: widget.password,
                          userName: widget.userName,
                        );
                      } else {
                        if (!mounted) return;
                        showSnackBar(context, 'OTP is incorrect');
                        setState(() {
                          image = 'assets/images/error x.json';
                        });
                        _clearAllPins();
                      }

                      if (!mounted) return;
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
                  SizedBox(height: 15),

                  _secondsRemaining > 0
                      ? Text(
                          'Resend in $_secondsRemaining s',
                          style: TextStyle(
                            color: context.onPrimary.withOpacity(0.5),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            setState(() {
                              if (image != 'assets/images/error x.json') {
                                isLoading = true;
                              }
                              image = 'assets/images/email sended.json';
                            });
                            await sendOtpCode();
                            if (!mounted) return;
                            setState(() {
                              isLoading = false;
                            });
                          },
                          child: Text(
                            'Resend verification code',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                  SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomTextOtp extends StatelessWidget {
  const _CustomTextOtp({required this.onChanged, required this.controller});
  final Function onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.onPrimary, width: 1.3),
        boxShadow: [
          BoxShadow(
            color: context.onPrimary.withValues(alpha: 0.15),
            spreadRadius: 5,
            blurRadius: 15,
            offset: Offset(0, 0),
          ),
        ],
      ),
      height: 68,
      width: 64,
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          onChanged(value);

          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        cursorColor: Theme.of(context).colorScheme.inversePrimary,
        decoration: InputDecoration(
          hintText: '0',
          hintStyle: TextStyle(
            fontFamily: 'San Francisco',
            color: context.onPrimary.withOpacity(0.6),
          ),

          border: InputBorder.none,
        ),
        style: TextStyle(fontSize: 35),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }
}
