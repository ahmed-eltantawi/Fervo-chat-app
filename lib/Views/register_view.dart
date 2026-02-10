import 'package:chat_with_me_now/Views/error_view.dart';
import 'package:chat_with_me_now/Views/otp_view.dart';
import 'package:chat_with_me_now/Widgets/custom_bottom.dart';
import 'package:chat_with_me_now/Widgets/custom_text_field.dart';
import 'package:chat_with_me_now/helper/consts.dart';
import 'package:chat_with_me_now/helper/extensions.dart';
import 'package:chat_with_me_now/helper/show_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  static String id = 'RegisterView';

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String? email;

  String? password;
  String? userName;

  final GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  SizedBox(height: 100),

                  Image.asset(kAppIcon, height: 100),
                  Text(
                    textAlign: TextAlign.center,
                    'Scalar Chat',
                    style: TextStyle(fontSize: 32, fontFamily: 'Pacifico'),
                  ),
                  SizedBox(height: 40),

                  Row(
                    children: [
                      Text('Register', style: TextStyle(fontSize: 25)),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 10),
                      CustomFormTextField(
                        hintText: 'Your Name',
                        onChanged: (value) {
                          userName = value.capitalize();
                        },
                      ),
                      SizedBox(height: 15),
                      CustomFormTextField(
                        hintText: 'Email',
                        onChanged: (value) {
                          email = value.toLowerCase();
                        },
                      ),
                      SizedBox(height: 15),
                      CustomFormTextField(
                        hide: true,
                        hintText: 'Password',
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomBottom(
                    text: 'Register',
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      if (formKey.currentState!.validate()) {
                        try {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return OTPView(
                                  email: email!,
                                  password: password!,
                                  userName: userName!,
                                );
                              },
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            showSnackBar(
                              context,
                              'The password provided is too weak.',
                            );
                          } else if (e.code == 'email-already-in-use') {
                            showSnackBar(
                              context,
                              'The account already exists for that email.',
                            );
                          }
                        } catch (e) {
                          showSnackBar(
                            context,
                            'There some thing Wrong, please try again',
                          );
                        }
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ErrorView();
                            },
                          ),
                        );
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already Have an account?  ", style: TextStyle()),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Sign In",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
