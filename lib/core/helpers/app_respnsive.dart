import 'dart:math';
import 'package:flutter/material.dart';

class AppResponsive extends StatelessWidget {
  const AppResponsive({
    super.key,
    required this.width,
    required this.child,
    this.autoCalculateMediaQueryData = true,
  });

  final double width;
  final Widget child;
  final bool autoCalculateMediaQueryData;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final aspectRatio = constraints.maxWidth / constraints.maxHeight;
        final scaledWidth = width;
        final scaledHeight = width / aspectRatio;

        final Widget childHolder = FittedBox(
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
          child: Container(
            width: scaledWidth,
            height: scaledHeight,
            alignment: Alignment.center,
            child: child,
          ),
        );

        if (autoCalculateMediaQueryData) {
          final mediaQueryData = MediaQuery.of(context);

          final scaledViewInsets = getAppInsets(
            mediaQueryData: mediaQueryData,
            screenSize: mediaQueryData.size,
            scaledSize: Size(scaledWidth, scaledHeight),
          );

          final scaledViewPadding = getResponsiveViewPadding(
            mediaQueryData: mediaQueryData,
            screenSize: mediaQueryData.size,
            scaledSize: Size(scaledWidth, scaledHeight),
          );

          final scaledPadding = getPadding(
            padding: scaledViewPadding,
            insets: scaledViewInsets,
          );

          return MediaQuery(
            data: mediaQueryData.copyWith(
              size: Size(scaledWidth, scaledHeight),
              viewInsets: scaledViewInsets,
              viewPadding: scaledViewPadding,
              padding: scaledPadding,
            ),
            child: childHolder,
          );
        }

        return childHolder;
      },
    );
  }

  // ================= FUNCTIONS =================

  EdgeInsets getPadding({
    required EdgeInsets padding,
    required EdgeInsets insets,
  }) {
    final scaledLeftPadding = max(0, padding.left - insets.left);
    final scaledTopPadding = max(0, padding.top - insets.top);
    final scaledRightPadding = max(0, padding.right - insets.right);
    final scaledBottomPadding = max(0, padding.bottom - insets.bottom);

    return EdgeInsets.fromLTRB(
      scaledLeftPadding.toDouble(),
      scaledTopPadding.toDouble(),
      scaledRightPadding.toDouble(),
      scaledBottomPadding.toDouble(),
    );
  }

  EdgeInsets getResponsiveViewPadding({
    required MediaQueryData mediaQueryData,
    required Size screenSize,
    required Size scaledSize,
  }) {
    final leftPaddingFactor =
        mediaQueryData.viewPadding.left / screenSize.width;
    final topPaddingFactor = mediaQueryData.viewPadding.top / screenSize.height;
    final rightPaddingFactor =
        mediaQueryData.viewPadding.right / screenSize.width;
    final bottomPaddingFactor =
        mediaQueryData.viewPadding.bottom / screenSize.height;

    return EdgeInsets.fromLTRB(
      leftPaddingFactor * scaledSize.width,
      topPaddingFactor * scaledSize.height,
      rightPaddingFactor * scaledSize.width,
      bottomPaddingFactor * scaledSize.height,
    );
  }

  EdgeInsets getAppInsets({
    required MediaQueryData mediaQueryData,
    required Size screenSize,
    required Size scaledSize,
  }) {
    final leftInsetFactor = mediaQueryData.viewInsets.left / screenSize.width;
    final topInsetFactor = mediaQueryData.viewInsets.top / screenSize.height;
    final rightInsetFactor = mediaQueryData.viewInsets.right / screenSize.width;
    final bottomInsetFactor =
        mediaQueryData.viewInsets.bottom / screenSize.height;

    return EdgeInsets.fromLTRB(
      leftInsetFactor * scaledSize.width,
      topInsetFactor * scaledSize.height,
      rightInsetFactor * scaledSize.width,
      bottomInsetFactor * scaledSize.height,
    );
  }
}
