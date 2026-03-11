import 'package:chat_with_me_now/Views/error_view.dart';
import 'package:chat_with_me_now/Views/otp_view.dart';
import 'package:chat_with_me_now/auth/isTheEmailExists.dart';
import 'package:chat_with_me_now/cubits/password_cubit/password_cubit.dart';
import 'package:chat_with_me_now/helper/show_snack_bar.dart';
import 'package:chat_with_me_now/helper/vibration.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
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
}
