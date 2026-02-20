import 'package:chat_with_me_now/Widgets/custom_bottom.dart';
import 'package:chat_with_me_now/helper/consts.dart';
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
  int? pin1;

  int? pin2;

  int? pin3;

  int? pin4;
  bool isLoading = false;
  String image = 'assets/images/email sended.json';

  @override
  void initState() {
    super.initState();
    sendOtpCode();
  }

  Future<void> sendOtpCode() async {
    bool result = await EmailOTP.sendOTP(email: widget.email);

    if (result) {
      showSnackBar(context, 'The OTP is sended correctly');
    } else {
      showSnackBar(context, 'Sending failed, Try again');
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
                      children: [
                        _CustomTextOtp(
                          onChanged: (value) {
                            pin1 = int.tryParse(value);
                          },
                        ),
                        _CustomTextOtp(
                          onChanged: (value) {
                            pin2 = int.tryParse(value);
                          },
                        ),
                        _CustomTextOtp(
                          onChanged: (value) {
                            pin3 = int.tryParse(value);
                          },
                        ),
                        _CustomTextOtp(
                          onChanged: (value) {
                            pin4 = int.tryParse(value);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 70),
                  CustomBottom(
                    text: 'Verify',
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      var otp = '$pin1$pin2$pin3$pin4';
                      if (otp.contains('null')) {
                        setState(() {
                          image = 'assets/images/error x.json';
                        });
                        showSnackBar(context, 'Enter all digest, please');
                      } else {
                        if (EmailOTP.verifyOTP(otp: otp)) {
                          showSnackBar(context, 'OTP is Correct');
                          await registerFunction(
                            context: context,
                            email: widget.email,
                            password: widget.password,
                            userName: widget.userName,
                          );
                        } else {
                          showSnackBar(context, 'OTP is incorrect');
                          setState(() {
                            image = 'assets/images/error x.json';
                          });
                        }
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        if (image != 'assets/images/error x.json') {
                          isLoading = true;
                        }
                        image = 'assets/images/email sended.json';
                      });
                      await sendOtpCode();
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
  const _CustomTextOtp({required this.onChanged});
  final Function onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kPrimaryColor, width: 1.3),
        color: Theme.of(context).colorScheme.onPrimary,
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.13),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 0),
          ),
        ],
      ),
      height: 68,
      width: 64,
      child: TextFormField(
        onSaved: (valeOfSquare) {},

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
            color: kPrimaryColor.withOpacity(0.6),
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
