import 'package:chat_with_me_now/Widgets/custom_form_text_field.dart';
import 'package:chat_with_me_now/Widgets/password_text_field_widget.dart';
import 'package:chat_with_me_now/cubits/password_cubit/password_cubit.dart';
import 'package:chat_with_me_now/theme/light_mode_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

Widget buildTestApp(Widget child) {
  return MaterialApp(
    theme: lightMode,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('CustomFormTextField renders label and hint text', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        CustomFormTextField(
          label: 'Email',
          prefixIcon: Icons.email_outlined,
          textInputAction: TextInputAction.next,
          hintText: 'example@gmail.com',
        ),
      ),
    );

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('example@gmail.com'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
  });

  testWidgets('PasswordTextField toggles password visibility', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        BlocProvider(
          create: (_) => PasswordCubit(),
          child: PasswordTextField(),
        ),
      ),
    );

    final textFormField = tester.widget<TextFormField>(find.byType(TextFormField));
    expect(textFormField.obscureText, isTrue);

    await tester.tap(find.byType(IconButton));
    await tester.pump();

    final updatedTextFormField = tester.widget<TextFormField>(
      find.byType(TextFormField),
    );
    expect(updatedTextFormField.obscureText, isFalse);
  });
}
