import 'dart:developer';

import 'package:chat_with_me_now/Widgets/custom_bottom.dart';
import 'package:chat_with_me_now/Widgets/custom_form_text_field.dart';
import 'package:chat_with_me_now/Widgets/page_label.dart';
import 'package:chat_with_me_now/helper/extensions.dart';
import 'package:chat_with_me_now/helper/show_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String image = "assets/images/reset_password.json";

  String? email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: ListView(
            children: [
              Center(
                child: Column(
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
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    PageLabel(
                      text:
                          "Enter your email to receive a\npassword reset link",
                    ),
                    SizedBox(height: 30),
                    CustomFormTextField(
                      onChanged: (value) {
                        email = value.toLowerCase();
                      },
                      hintText: 'example@gmail.com',
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icons.email_outlined,
                      label: 'Email Address',
                    ),
                    SizedBox(height: 40),
                    CustomBottom(
                      text: "Send Reset Link",
                      onTap: () async {
                        log('$email');
                        if (email != null) {
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: email!,
                            );
                            setState(() {
                              image =
                                  "assets/images/reset_password_email_is_sented.json";
                            });
                            showSnackBar(
                              context,
                              "Password reset link sent! Check your email",
                            );
                          } on FirebaseException catch (e) {
                            showSnackBar(context, e.message!);
                          } catch (e) {
                            showSnackBar(context, e.toString());
                          }
                        } else {
                          showSnackBar(context, "Write your email address");
                        }
                      },
                    ),
                    SizedBox(height: 200),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Remembered your password? ",
                          style: TextStyle(fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Log in",
                            style: TextStyle(
                              fontSize: 16,
                              color: context.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
