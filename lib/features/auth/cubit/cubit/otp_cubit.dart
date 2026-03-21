import 'dart:async';

import 'package:chat_with_me_now/config/constants/images.dart';
import 'package:chat_with_me_now/core/helpers/show_snack_bar.dart';
import 'package:chat_with_me_now/features/auth/cubit/password_cubit/password_cubit.dart';
import 'package:chat_with_me_now/features/auth/services/auth_service.dart';
import 'package:chat_with_me_now/features/auth/services/otp_services.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());
  List<String> pins = ['', '', '', ''];
  List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  bool isLoading = false;
  String image = Assets.imagesEmailSended;

  final int secondsRemaining = 0;
  Timer? _timer;

  bool get isComplete => pins.every((p) => p.isNotEmpty);

  Future<void> verify({
    required BuildContext context,
    required String email,
    required String userName,
  }) async {
    if (!isComplete) {
      image = Assets.imagesErrorX;

      showSnackBar(context, 'Please enter all digits');
      return;
    }
    emit(OtpLoading());
    String otp = pins.join();
    if (EmailOTP.verifyOTP(otp: otp)) {
      showSnackBar(context, 'OTP is correct');
      await AuthService.registerFunction(
        context: context,
        email: email,
        password: BlocProvider.of<PasswordCubit>(context).password,
        userName: userName,
      );
      emit(OtpSuccess());
    } else {
      showSnackBar(context, 'OTP is incorrect');

      image = Assets.imagesErrorX;

      OtpServices.clearAllPins(controllers: controllers, pins: pins);
      emit(OtpFailure());
      return;
    }
  }

  Future<void> sendOtp({
    required BuildContext context,
    required String email,
  }) async {
    if (image != Assets.imagesErrorX) {
      emit(OtpLoading());
    }
    image = Assets.imagesEmailSended;

    try {
      await OtpServices.sendOtpCode(
        context: context,
        email: email,

        secondsRemaining: secondsRemaining,
        timer: _timer,
      );
      emit(OtpSuccess());
    } catch (e) {
      emit(OtpFailure());
    }
  }
}
