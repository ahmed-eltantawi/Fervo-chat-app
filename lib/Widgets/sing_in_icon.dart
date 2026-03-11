import 'package:chat_with_me_now/helper/extensions.dart';
import 'package:flutter/material.dart';

class SingInIcons extends StatelessWidget {
  const SingInIcons({super.key, required this.image, required this.onTap});
  final String image;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: context.onPrimary.withValues(alpha: 0.2),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(200),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(200),
          ),
          margin: EdgeInsets.all(.4),
          child: Image.asset(image),
        ),
      ),
    );
  }
}
