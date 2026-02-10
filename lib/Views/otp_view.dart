import 'dart:developer';

import 'package:chat_with_me_now/Widgets/custom_bottom.dart';
import 'package:chat_with_me_now/helper/register_function.dart';
import 'package:chat_with_me_now/helper/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPView extends StatelessWidget {
  OTPView({
    super.key,
    required this.email,
    required this.password,
    required this.userName,
  });
  final String email;
  final String password;
  final String userName;
  int? pin1;
  int? pin2;
  int? pin3;
  int? pin4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Spacer(flex: 2),
            Text(
              'We just sent an email',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              'Enter the security code we sent to:',
              style: TextStyle(fontSize: 16),
            ),

            Text(email),
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
            SizedBox(height: 100),
            CustomBottom(
              text: 'Verify',
              onTap: () async {
                //* The OTP value be setting here
                //*=============================================================
                //*=============================================================
                // TODO: use it with the package of the otp to check
                // TODO: The email is the email's user
                // TODO: And try to inhace the Ui of the OTP view
                // TODO: another thing Link this view with the regestier view
                // I think the better way to to that is the navgator . push
                // also make sure after all of this the app flow is working well
                // ? The App flow should be when the user click on register view
                // ? move him to OTP view then move him to chat app
                //*=============================================================
                //*=============================================================
                var x = '$pin1$pin2$pin3$pin4';
                if (x.contains('null')) {
                  showSnackBar(context, 'Enter all digest, please');
                } else {
                  log(x);

                  await registerFunction(
                    context: context,
                    email: email,
                    password: password,
                    userName: userName,
                  );
                }
              },
            ),
            Spacer(flex: 5),
          ],
        ),
      ),
    );
  }
}

class _CustomTextOtp extends StatelessWidget {
  _CustomTextOtp({super.key, required this.onChanged});
  Function onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onPrimary,
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
            color: Colors.grey.withOpacity(0.5),
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
