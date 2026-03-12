import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.fit,
    this.repeatForLottieFiles,
  });
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String image;
  final bool? repeatForLottieFiles;

  @override
  Widget build(BuildContext context) {
    final img = image.toLowerCase();

    if (img.startsWith("http")) {
      return Image.network(image, height: height, width: width, fit: fit);
    }

    if (img.endsWith(".svg")) {
      return SvgPicture.asset(
        image,
        height: height,
        width: width,
        fit: fit ?? BoxFit.contain,
      );
    }

    if (img.endsWith(".json")) {
      return Lottie.asset(
        image,
        height: height,
        width: width,
        fit: fit,
        repeat: repeatForLottieFiles,
        key: ValueKey(image),
      );
    }

    if (img.endsWith(".png") || img.endsWith(".jpg") || img.endsWith(".jpeg")) {
      return Image.asset(image, height: height, width: width, fit: fit);
    }
    return const SizedBox.shrink();
  }
}
