import 'package:chat_with_me_now/core/helpers/extensions.dart';
import 'package:chat_with_me_now/core/widgets/app_icon_widget.dart';
import 'package:chat_with_me_now/core/widgets/custom_button.dart';
import 'package:chat_with_me_now/core/widgets/custom_form_text_field.dart';
import 'package:chat_with_me_now/core/widgets/page_label.dart';
import 'package:chat_with_me_now/features/auth/bloc/auth_bloc.dart';
import 'package:chat_with_me_now/features/auth/widgets/password_text_field_widget.dart';
import 'package:chat_with_me_now/features/auth/widgets/terms_and_conditions_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  static String id = 'RegisterView';

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String? email;

  String? userName;

  final GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;
  bool isCheckBoxClicked = false;
  bool showErrorOfCheckBox = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          isLoading = true;
        } else {
          isLoading = false;
        }
      },
      builder: (context, state) {
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
                        child: PageLabel(
                          text: 'Create your distraction-free chats today',
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
                      PasswordTextField(),
                      SizedBox(height: 20),
                      TermsAndConditionsWidget(),
                      SizedBox(height: 20),
                      CustomBottom(
                        text: 'Create Account',
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<AuthBloc>(context).add(
                              RegisterEvent(
                                context: context,
                                email: email,
                                userName: userName,
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already Have an account?  ",
                            style: TextStyle(),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: context.onPrimary,
                              ),
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
      },
    );
  }
}
