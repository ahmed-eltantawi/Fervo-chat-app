import 'package:chat_with_me_now/core/helpers/extensions.dart';
import 'package:chat_with_me_now/core/helpers/web_view.dart';
import 'package:chat_with_me_now/features/auth/bloc/auth_bloc.dart';
import 'package:chat_with_me_now/features/auth/widgets/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TermsAndConditionsWidget extends StatefulWidget {
  const TermsAndConditionsWidget({super.key});

  @override
  State<TermsAndConditionsWidget> createState() =>
      _TermsAndConditionsWidgetState();
}

class _TermsAndConditionsWidgetState extends State<TermsAndConditionsWidget> {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              bloc.isCheckBoxClicked = !bloc.isCheckBoxClicked;
            });
          },
          child: CustomCheckbox(
            value: bloc.isCheckBoxClicked,
            onChanged: (value) {
              setState(() {
                bloc.isCheckBoxClicked = value ?? false;
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
                          url: 'https://fervo-ahemdeltantawi.netlify.app/',
                        );
                      },
                    ),
                  );
                },
                child: Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.onPrimary,
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
                    color: context.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
