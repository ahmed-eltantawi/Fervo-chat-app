import 'package:chat_with_me_now/Views/home_view.dart';
import 'package:chat_with_me_now/Views/register_view.dart';
import 'package:chat_with_me_now/Views/reset_password_view.dart';
import 'package:chat_with_me_now/Widgets/app_icon_widget.dart';
import 'package:chat_with_me_now/Widgets/custom_bottom.dart';
import 'package:chat_with_me_now/Widgets/custom_text_field.dart';
import 'package:chat_with_me_now/Widgets/horezantial_text_line.dart';
import 'package:chat_with_me_now/auth/sing_in_methods.dart';
import 'package:chat_with_me_now/auth/make_user_and_sing_in_function.dart';
import 'package:chat_with_me_now/helper/consts.dart';
import 'package:chat_with_me_now/helper/show_snack_bar.dart';
import 'package:chat_with_me_now/auth/user_login.dart';
import 'package:chat_with_me_now/helper/vibration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:email_validator/email_validator.dart';

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

  bool passwordHide = true;

  IconData passwordIcon = Icons.visibility_off_outlined;

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
                      SizedBox(height: 50),
                      AppIconWidget(),
                      Text(
                        'Enter your details to access your chats',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 40),
                      CustomFormTextField(
                        label: 'Email',
                        prefixIcon: Icons.email_outlined,
                        textInputAction: TextInputAction.next,
                        hintText: 'yourName@example.com',
                        onChanged: (value) {
                          email = value.toLowerCase();
                        },
                      ),
                      SizedBox(height: 30),
                      Stack(
                        alignment: AlignmentGeometry.xy(1, .8),
                        children: [
                          CustomFormTextField(
                            label: 'Password',
                            prefixIcon: Icons.lock_outlined,
                            textInputAction: TextInputAction.done,
                            hide: passwordHide,
                            hintText: '********',
                            onChanged: (value) {
                              password = value;
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              if (passwordIcon ==
                                  Icons.visibility_off_outlined) {
                                passwordIcon = Icons.remove_red_eye_outlined;
                                passwordHide = false;
                              } else {
                                passwordIcon = Icons.visibility_off_outlined;
                                passwordHide = true;
                              }
                              setState(() {
                                passwordIcon;
                                passwordHide;
                              });
                            },
                            icon: Icon(
                              passwordIcon,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ResetPassword();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 16,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      CustomBottom(text: 'Sign In', onTap: singInMethod),
                      SizedBox(height: 40),
                      HorizontalTextLine(text: 'Or continue with'),
                      SizedBox(height: 30),
                      googleAndFacebookSingIn(context),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?  ",
                            style: TextStyle(fontSize: 18),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, RegisterView.id);
                            },
                            child: Text(
                              "Sing Up",
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
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

  Row googleAndFacebookSingIn(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        singInIcons(
          image: 'assets/images/google icon.png',
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
              showSnackBar(context, 'Wrong with Google sing in, try again');
            }
            setState(() {
              isLoading = false;
            });
          },
        ),
        SizedBox(width: 20),
        singInIcons(
          image: 'assets/images/facebook-icon.png',
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
                showSnackBar(context, 'This email is used before.');
              } else {
                showSnackBar(context, 'Wrong with Facebook sing in, try again');
              }
            }
            setState(() {
              isLoading = false;
            });
          },
        ),
      ],
    );
  }

  Future<dynamic> singInMethod() async {
    setState(() {
      isLoading = true;
    });
    if (formKey.currentState!.validate()) {
      final bool isConnected = await InternetConnection().hasInternetAccess;
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
            Navigator.pushNamed(context, HomeView.id, arguments: email);
          } on FirebaseAuthException catch (e) {
            vibration();
            if (!mounted) return;
            if (e.code == 'user-not-found') {
              showSnackBar(context, 'No user found for that email.');
            } else if (e.code == 'invalid-credential') {
              showSnackBar(context, 'Wrong password provided for that user.');
            }
          } catch (e) {
            vibration();
            showSnackBar(context, 'There some thing Wrong, please try again');
          }
        }
      }
    }
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }
}

class singInIcons extends StatelessWidget {
  const singInIcons({super.key, required this.image, required this.onTap});
  final String image;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.13),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(200),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(200),
          ),
          margin: EdgeInsets.all(.4),
          child: Image.asset(image),
        ),
      ),
    );
  }
}
