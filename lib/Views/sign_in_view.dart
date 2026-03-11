import 'package:chat_with_me_now/Views/register_view.dart';
import 'package:chat_with_me_now/Views/reset_password_view.dart';
import 'package:chat_with_me_now/Widgets/app_icon_widget.dart';
import 'package:chat_with_me_now/Widgets/custom_bottom.dart';
import 'package:chat_with_me_now/Widgets/custom_form_text_field.dart';
import 'package:chat_with_me_now/Widgets/google_and_facebook_login_widget.dart';
import 'package:chat_with_me_now/Widgets/horizontal_text_line.dart';
import 'package:chat_with_me_now/Widgets/page_label.dart';
import 'package:chat_with_me_now/cubits/login_cubit/login_cubit.dart';
import 'package:chat_with_me_now/cubits/password_cubit/password_cubit.dart';
import 'package:chat_with_me_now/helper/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else {
          isLoading = false;
        }
      },
      builder: (context, state) {
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
                          PageLabel(
                            text: "Enter your details to access your chats",
                          ),
                          SizedBox(height: 40),
                          CustomFormTextField(
                            label: 'Email',
                            prefixIcon: Icons.email_outlined,
                            textInputAction: TextInputAction.next,
                            hintText: 'example@gmail.com',
                            onChanged: (value) {
                              email = value.toLowerCase();
                            },
                          ),
                          SizedBox(height: 30),
                          BlocConsumer<PasswordCubit, PasswordState>(
                            listener: (context, state) {
                              if (state is ShowPassword) {
                                passwordHide = false;
                                passwordIcon = BlocProvider.of<PasswordCubit>(
                                  context,
                                ).passwordIcon;
                              } else {
                                passwordHide = true;
                                passwordIcon = BlocProvider.of<PasswordCubit>(
                                  context,
                                ).passwordIcon;
                              }
                            },
                            builder: (context, state) {
                              return Stack(
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
                                    onPressed: BlocProvider.of<PasswordCubit>(
                                      context,
                                    ).changeThePasswordState,

                                    icon: Icon(
                                      passwordIcon,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              );
                            },
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
                                    color: context.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          CustomBottom(
                            text: 'Sign In',
                            onTap: () {
                              BlocProvider.of<LoginCubit>(context).singInMethod(
                                context: context,
                                email: email,
                                formKey: formKey,
                                password: password,
                              );
                            },
                          ),
                          SizedBox(height: 40),
                          HorizontalTextLine(text: 'Or continue with'),
                          SizedBox(height: 30),
                          GoogleAndFacebookSingInWidget(),
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
                                    color: context.onPrimary,
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
      },
    );
  }
}
