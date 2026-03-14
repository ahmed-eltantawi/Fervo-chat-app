import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_with_me_now/Views/error_view.dart';
import 'package:chat_with_me_now/Views/otp_view.dart';
import 'package:chat_with_me_now/Features/auth/isTheEmailExists.dart';
import 'package:chat_with_me_now/cubits/password_cubit/password_cubit.dart';
import 'package:chat_with_me_now/helper/show_snack_bar.dart';
import 'package:chat_with_me_now/helper/vibration.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:chat_with_me_now/Views/home_view.dart';
import 'package:chat_with_me_now/Features/auth/make_user_and_sing_in_function.dart';
import 'package:chat_with_me_now/Features/auth/sing_in_methods.dart';
import 'package:chat_with_me_now/Features/auth/user_login.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  bool isCheckBoxClicked = false;
  AuthBloc() : super(AuthInitial()) {
    //*================== Login with email and password =================
    on<AuthEvent>((event, emit) async {
      if (event is LoginEvent) {
        emit(LoginLoading());
        final bool isConnected = await InternetConnection().hasInternetAccess;
        if (!isConnected) {
          showSnackBar(event.context, 'No internet connection.');
          vibration();
        } else {
          if (!EmailValidator.validate(event.email)) {
            showSnackBar(
              event.context,
              'Email is not valid email, try To enter a right one',
            );
            vibration();
          } else {
            try {
              await userLogin(event.context, event.email, event.password);
              Navigator.pushNamed(
                event.context,
                HomeView.id,
                arguments: event.email,
              );
              emit(LoginSuccess());
              return;
            } on FirebaseAuthException catch (e) {
              vibration();
              if (e.code == 'user-not-found') {
                showSnackBar(event.context, 'No user found for that email.');
              } else if (e.code == 'invalid-credential') {
                showSnackBar(
                  event.context,
                  'Wrong password provided for that user.',
                );
              }
            } catch (e) {
              vibration();
              showSnackBar(
                event.context,
                'There some thing Wrong, please try again',
              );
            }
            emit(LoginFailure());
          }
        }
      }
      //*================== Google Login =================
      else if (event is GoogleLoginEvent) {
        emit(LoginLoading());
        try {
          await SignInMethods.google();
          await _makeGoogleOrFacebookUser(event.context);
          emit(LoginSuccess());
        } catch (e) {
          vibration();
          showSnackBar(event.context, 'Wrong with Google sing in, try again');
          emit(LoginFailure());
        }
      }
      //*================== Facebook Login =================
      else if (event is FacebookLoginEvent) {
        emit(LoginLoading());
        try {
          await SignInMethods.facebook();
          await _makeGoogleOrFacebookUser(event.context);
          emit(LoginSuccess());
        } catch (e) {
          emit(LoginFailure());
          vibration();
          if (e.toString() ==
              ' [firebase_auth/account-exists-with-different-credential] An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.') {
            showSnackBar(event.context, 'This email is used before.');
          } else {
            showSnackBar(
              event.context,
              'Wrong with Facebook sing in, try again',
            );
          }
        }
      }
      //*=================================================
      //*================== Register Event ===============
      else if (event is RegisterEvent) {
        emit(RegisterLoading());
        if (!await InternetConnection().hasInternetAccess) {
          showSnackBar(event.context, 'No internet connection.');
          vibration();
        } else {
          String email = event.email!;
          String userName = event.userName!;
          if (!EmailValidator.validate(email)) {
            vibration();
            showSnackBar(
              event.context,
              'Email is not valid email, try To enter a right one',
            );
            emit(RegisterFailure());
            return;
          }

          if (await isThisEmailExists(email)) {
            vibration();
            showSnackBar(
              event.context,
              "This Email ID already Associated with Another Account.",
            );
            emit(RegisterFailure());
          } else if (!isCheckBoxClicked) {
            showSnackBar(
              event.context,
              "Please confirm the terms & conditions",
            );
            emit(CheckBoxError());
          } else {
            try {
              Navigator.push(
                event.context,
                MaterialPageRoute(
                  builder: (context) {
                    return OTPView(email: email, userName: userName);
                  },
                ),
              );
              emit(RegisterSuccess());
            } on FirebaseAuthException catch (e) {
              emit(RegisterFailure());
              vibration();
              if (e.code == 'weak-password') {
                showSnackBar(
                  event.context,
                  'The password provided is too weak.',
                );
              } else if (e.code == 'email-already-in-use') {
                showSnackBar(
                  event.context,
                  'The account already exists for that email.',
                );
                return;
              }
            } catch (e) {
              emit(RegisterFailure());
              vibration();
              showSnackBar(
                event.context,
                'There some thing Wrong, please try again',
              );
            }
          }
        }
        emit(RegisterFailure());
        vibration();
        Navigator.push(
          event.context,
          MaterialPageRoute(
            builder: (context) {
              return ErrorView();
            },
          ),
        );
      }
    });
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
