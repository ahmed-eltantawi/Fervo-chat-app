import 'package:chat_with_me_now/Views/error_view.dart';
import 'package:chat_with_me_now/Views/otp_view.dart';
import 'package:chat_with_me_now/Widgets/app_icon_widget.dart';
import 'package:chat_with_me_now/Widgets/custom_bottom.dart';
import 'package:chat_with_me_now/Widgets/custom_check_box.dart';
import 'package:chat_with_me_now/Widgets/custom_text_field.dart';
import 'package:chat_with_me_now/helper/consts.dart';
import 'package:chat_with_me_now/helper/extensions.dart';
import 'package:chat_with_me_now/auth/isTheEmailExists.dart';
import 'package:chat_with_me_now/helper/show_snack_bar.dart';
import 'package:chat_with_me_now/helper/vibration.dart';
import 'package:chat_with_me_now/helper/web_view.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
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
  bool passwordHide = true;
  bool isCheckBoxClicked = false;
  bool showErrorOfCheckBox = false;

  IconData showAndHidePasswordIcon = Icons.visibility_off_outlined;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  SizedBox(height: 20),
                  AppIconWidget(),
                  Center(
                    child: Text(
                      'Create your distraction-free chats today',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  CustomFormTextField(
                    label: 'Full Name',
                    prefixIcon: Icons.person_outlined,
                    textInputAction: TextInputAction.next,
                    hintText: 'Your Name',
                    onChanged: (value) {
                      userName = value.capitalize();
                    },
                  ),
                  SizedBox(height: 20),
                  CustomFormTextField(
                    label: 'Email',
                    prefixIcon: Icons.email_outlined,
                    textInputAction: TextInputAction.next,
                    hintText: 'Email',
                    onChanged: (value) {
                      email = value.toLowerCase();
                    },
                  ),
                  SizedBox(height: 20),
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
                          if (showAndHidePasswordIcon ==
                              Icons.visibility_off_outlined) {
                            showAndHidePasswordIcon =
                                Icons.remove_red_eye_outlined;
                            passwordHide = false;
                          } else {
                            showAndHidePasswordIcon =
                                Icons.visibility_off_outlined;
                            passwordHide = true;
                          }
                          setState(() {
                            showAndHidePasswordIcon;
                            passwordHide;
                          });
                        },
                        icon: Icon(
                          showAndHidePasswordIcon,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isCheckBoxClicked = !isCheckBoxClicked;
                          });
                        },
                        child: CustomCheckbox(
                          showErrorOfCheckBox: showErrorOfCheckBox,
                          value: isCheckBoxClicked,
                          onChanged: (value) {
                            setState(() {
                              isCheckBoxClicked = value ?? false;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Text('I agree to the '),
                            GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return WebView(
                                        url:
                                            'https://fervo-ahemdeltantawi.netlify.app/',
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                'Terms & Conditions',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            Text(' and '),
                            GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return WebView(
                                        url:
                                            'https://fervo-ahemdeltantawi.netlify.app/deleating-user-info',
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  CustomBottom(
                    text: 'Create Account',
                    onTap: () async {
                      if (isCheckBoxClicked) {
                        setState(() {
                          isLoading = true;
                        });
                        final bool isConnected =
                            await InternetConnection().hasInternetAccess;
                        if (!isConnected) {
                          showSnackBar(context, 'No internet connection.');
                          vibration();
                        } else {
                          if (formKey.currentState!.validate()) {
                            if (!EmailValidator.validate(email!)) {
                              vibration();

                              showSnackBar(
                                context,
                                'Email is not valid email, try To enter a right one',
                              );
                              setState(() {
                                isLoading = false;
                              });
                              return;
                            }

                            if (await isThisEmailExists(email!)) {
                              vibration();
                              showSnackBar(
                                context,
                                "This Email ID already Associated with Another Account.",
                              );
                            } else {
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
                                vibration();

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
                                  setState(() {
                                    isLoading = false;
                                  });
                                  return;
                                }
                              } catch (e) {
                                vibration();

                                showSnackBar(
                                  context,
                                  'There some thing Wrong, please try again',
                                );
                              }
                            }
                          } else if (email != null &&
                              userName != null &&
                              password != null) {
                            vibration();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ErrorView();
                                },
                              ),
                            );
                          }
                        }
                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        showSnackBar(
                          context,
                          "Please confirm the terms & conditions",
                        );
                        setState(() {
                          showErrorOfCheckBox = true;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 20),
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
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
