import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_with_me_now/Views/error_view.dart';
import 'package:chat_with_me_now/Views/otp_view.dart';
import 'package:chat_with_me_now/auth/isTheEmailExists.dart';
import 'package:chat_with_me_now/cubits/password_cubit/password_cubit.dart';
import 'package:chat_with_me_now/helper/show_snack_bar.dart';
import 'package:chat_with_me_now/helper/vibration.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:chat_with_me_now/Views/home_view.dart';
import 'package:chat_with_me_now/auth/make_user_and_sing_in_function.dart';
import 'package:chat_with_me_now/auth/sing_in_methods.dart';
import 'package:chat_with_me_now/auth/user_login.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  //* ==== Register Functions ====
  bool isCheckBoxClicked = false;
  Future<void> registerMethod({
    required BuildContext context,
    required String? email,
    required String? userName,
    required dynamic formKey,
  }) async {
    emit(RegisterLoading());

    if (!await InternetConnection().hasInternetAccess) {
      showSnackBar(context, 'No internet connection.');
      vibration();
    } else {
      if (formKey.currentState!.validate()) {
        email!;
        userName!;
        if (!EmailValidator.validate(email)) {
          vibration();
          showSnackBar(
            context,
            'Email is not valid email, try To enter a right one',
          );
          emit(RegisterFailure());
          return;
        }

        if (await isThisEmailExists(email)) {
          vibration();
          showSnackBar(
            context,
            "This Email ID already Associated with Another Account.",
          );
          emit(RegisterFailure());
        } else if (!isCheckBoxClicked) {
          showSnackBar(context, "Please confirm the terms & conditions");
          emit(CheckBoxError());
        } else {
          try {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return OTPView(
                    email: email,
                    password: BlocProvider.of<PasswordCubit>(context).password!,
                    userName: userName,
                  );
                },
              ),
            );
            emit(RegisterSuccess());
          } on FirebaseAuthException catch (e) {
            emit(RegisterFailure());
            vibration();
            if (e.code == 'weak-password') {
              showSnackBar(context, 'The password provided is too weak.');
            } else if (e.code == 'email-already-in-use') {
              showSnackBar(
                context,
                'The account already exists for that email.',
              );
              return;
            }
          } catch (e) {
            emit(RegisterFailure());
            vibration();
            showSnackBar(context, 'There some thing Wrong, please try again');
          }
        }
      } else if (BlocProvider.of<PasswordCubit>(context).password != null) {
        emit(RegisterFailure());
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
  }

  //*==============================================================
  //* ====================== Login Functions ======================
  //*==============================================================

  Future<void> singInMethod({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String? email,
    required String? password,
  }) async {
    if (formKey.currentState!.validate()) {
      email!;
      password!;
      emit(LoginLoading());
      final bool isConnected = await InternetConnection().hasInternetAccess;
      if (!isConnected) {
        showSnackBar(context, 'No internet connection.');
        vibration();
      } else {
        if (!EmailValidator.validate(email)) {
          showSnackBar(
            context,
            'Email is not valid email, try To enter a right one',
          );
          vibration();
        } else {
          try {
            await userLogin(context, email, password);
            email = '';
            password = '';
            Navigator.pushNamed(context, HomeView.id, arguments: email);
            emit(LoginSuccess());
            return;
          } on FirebaseAuthException catch (e) {
            vibration();
            if (e.code == 'user-not-found') {
              showSnackBar(context, 'No user found for that email.');
            } else if (e.code == 'invalid-credential') {
              showSnackBar(context, 'Wrong password provided for that user.');
            }
          } catch (e) {
            vibration();
            showSnackBar(context, 'There some thing Wrong, please try again');
          }
          emit(LoginFailure());
        }
      }
    }
  }

  Future<void> googleLogin({required BuildContext context}) async {
    emit(LoginLoading());
    try {
      await SignInMethods.google();
      await _makeGoogleOrFacebookUser(context);
      emit(LoginSuccess());
    } catch (e) {
      vibration();
      showSnackBar(context, 'Wrong with Google sing in, try again');
      emit(LoginFailure());
    }
  }

  Future<void> facebookLogin({required BuildContext context}) async {
    emit(LoginLoading());
    try {
      await SignInMethods.facebook();
      await _makeGoogleOrFacebookUser(context);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure());
      vibration();
      if (e.toString() ==
          ' [firebase_auth/account-exists-with-different-credential] An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.') {
        showSnackBar(context, 'This email is used before.');
      } else {
        showSnackBar(context, 'Wrong with Facebook sing in, try again');
      }
    }
  }

  Future<void> _makeGoogleOrFacebookUser(BuildContext context) async {
    User user = FirebaseAuth.instance.currentUser!;
    await makeUser(
      context,
      user.email!,
      user.uid,
      user.displayName!,
      image: user.photoURL,
    );
  }
}
