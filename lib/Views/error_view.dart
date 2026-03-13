import 'package:chat_with_me_now/Widgets/error_widget.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ERROR'), centerTitle: true),
      body: CustomErrorWidget(),
    );
  }
}
