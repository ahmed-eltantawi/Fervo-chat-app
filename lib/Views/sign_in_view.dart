import 'package:chat_with_me_now/Views/home_view.dart';
import 'package:chat_with_me_now/Views/register_view.dart';
import 'package:chat_with_me_now/Widgets/app_icon_widget.dart';
import 'package:chat_with_me_now/Widgets/custom_bottom.dart';
import 'package:chat_with_me_now/Widgets/custom_text_field.dart';
import 'package:chat_with_me_now/auth/sing_in_methods.dart';
import 'package:chat_with_me_now/auth/make_user_and_sing_in_function.dart';
import 'package:chat_with_me_now/helper/show_snack_bar.dart';
import 'package:chat_with_me_now/auth/user_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:email_validator/email_validator.dart';
import 'package:vibration/vibration.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  static String id = 'SignIn';

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String? email;

  String? password;

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
                  Column(
                    children: [
                      SizedBox(height: 100),
                      AppIconWidget(),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Sign In', style: TextStyle(fontSize: 25)),
                        ],
                      ),
                      SizedBox(height: 10),

                      CustomFormTextField(
                        textInputAction: TextInputAction.next,

                        hintText: 'Email',
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                      SizedBox(height: 15),
                      CustomFormTextField(
                        textInputAction: TextInputAction.done,

                        hide: true,
                        hintText: 'Password',
                        onChanged: (value) {
                          password = value;
                        },
                      ),

                      SizedBox(height: 20),
                      CustomBottom(
                        text: 'Sign In',
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            final bool isConnected =
                                await InternetConnection().hasInternetAccess;
                            if (!isConnected) {
                              showSnackBar(context, 'No internet connection.');
                              vibration();
                            } else {
                              if (!EmailValidator.validate(email!)) {
                                showSnackBar(
                                  context,
                                  'Email is not valid email, try To enter a right one',
                                );
                                vibration();
                              } else {
                                try {
                                  await userLogin(context, email!, password!);
                                  if (!mounted) return;
                                  email = '';
                                  password = '';
                                  Navigator.pushNamed(
                                    context,
                                    HomeView.id,
                                    arguments: email,
                                  );
                                } on FirebaseAuthException catch (e) {
                                  vibration();

                                  if (!mounted) return;
                                  if (e.code == 'user-not-found') {
                                    showSnackBar(
                                      context,
                                      'No user found for that email.',
                                    );
                                  } else if (e.code == 'invalid-credential') {
                                    showSnackBar(
                                      context,
                                      'Wrong password provided for that user.',
                                    );
                                  }
                                } catch (e) {
                                  vibration();
                                  showSnackBar(
                                    context,
                                    'There some thing Wrong, please try again',
                                  );
                                }
                              }
                            }
                            if (!mounted) return;

                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 15),
                      CustomBottom(
                        text: 'Sign In with Google',
                        onTap: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            await SignInMethods.google();
                            User user = FirebaseAuth.instance.currentUser!;

                            await makeUser(
                              context,
                              user.email,
                              user.uid,
                              user.displayName,
                              image: user.photoURL,
                            );
                          } catch (e) {
                            vibration();
                            showSnackBar(
                              context,
                              'Wrong with Google sing in, try again',
                            );
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                      ),
                      SizedBox(height: 15),

                      CustomBottom(
                        text: 'Sign In with Facebook',
                        onTap: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            await SignInMethods.facebook();
                            User user = FirebaseAuth.instance.currentUser!;
                            await makeUser(
                              context,
                              user.email,
                              user.uid,
                              user.displayName,
                              image: user.photoURL,
                            );
                          } catch (e) {
                            vibration();
                            if (e.toString() ==
                                ' [firebase_auth/account-exists-with-different-credential] An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.') {
                              showSnackBar(
                                context,
                                'This email is used before.',
                              );
                            } else {
                              showSnackBar(
                                context,
                                'Wrong with Facebook sing in, try again',
                              );
                            }
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
                          Text("Don't Have an account?  ", style: TextStyle()),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, RegisterView.id);
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
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

  void vibration() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate();
    }
  }
}
