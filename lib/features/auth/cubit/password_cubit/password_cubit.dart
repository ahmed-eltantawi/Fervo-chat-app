import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'password_state.dart';

class PasswordCubit extends Cubit<PasswordState> {
  PasswordCubit() : super(PasswordInitial());
  late String password;
  IconData passwordIcon = Icons.visibility_off_outlined;
  void changeThePasswordState() {
    if (passwordIcon == Icons.visibility_off_outlined) {
      passwordIcon = Icons.remove_red_eye_outlined;
      emit(ShowPassword());
    } else {
      passwordIcon = Icons.visibility_off_outlined;
      emit(HidePassword());
    }
  }
}
