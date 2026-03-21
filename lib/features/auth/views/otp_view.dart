import 'package:chat_with_me_now/core/widgets/custom_button.dart';
import 'package:chat_with_me_now/features/auth/cubit/cubit/otp_cubit.dart';
import 'package:chat_with_me_now/core/helpers/extensions.dart';
import 'package:chat_with_me_now/features/auth/widgets/custom_text_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class OTPView extends StatelessWidget {
  const OTPView({super.key, required this.email, required this.userName});
  final String email;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpCubit, OtpState>(
      listener: (context, state) {},
      builder: (context, state) {
        bool isLoading;
        if (state is OtpLoading) {
          isLoading = true;
        } else {
          isLoading = false;
        }
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 250,
                        child: LottieBuilder.asset(
                          BlocProvider.of<OtpCubit>(context).image,
                          repeat: false,
                          key: ValueKey(
                            BlocProvider.of<OtpCubit>(context).image,
                          ),
                        ),
                      ),
                      Text(
                        "Verify it's you",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "We've sent a 4-digit code to",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        email,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 50),
                      Form(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            4,
                            (index) => CustomTextOtp(
                              controller: BlocProvider.of<OtpCubit>(
                                context,
                              ).controllers[index],
                              onChanged: (value) {
                                BlocProvider.of<OtpCubit>(context).pins[index] =
                                    value;
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 70),
                      CustomBottom(
                        text: 'Verify',
                        onTap: () async {
                          await BlocProvider.of<OtpCubit>(context).verify(
                            context: context,
                            email: email,
                            userName: userName,
                          );
                        },
                      ),
                      SizedBox(height: 15),

                      BlocProvider.of<OtpCubit>(context).secondsRemaining > 0
                          ? Text(
                              'Resend in ${BlocProvider.of<OtpCubit>(context).secondsRemaining} s',
                              style: TextStyle(
                                color: context.onPrimary.withOpacity(0.5),
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                await BlocProvider.of<OtpCubit>(
                                  context,
                                ).sendOtp(context: context, email: email);
                              },
                              child: Text(
                                'Resend verification code',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                      SizedBox(height: 30),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
