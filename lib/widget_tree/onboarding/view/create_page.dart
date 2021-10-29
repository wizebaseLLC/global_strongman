import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

/// Returns a [PageViewModel]
///
/// This includes the image ([assetName]), and the [body]
PageViewModel createPage({
  required BuildContext context,
  required String assetName,
  required List<Widget> body,
  required GlobalKey<IntroductionScreenState> controller,
  required String title,
}) {
  var height = MediaQuery.of(context).size.height;

  return PageViewModel(
    title: title,
    bodyWidget: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: body,
    ),
    image: ShaderMask(
      shaderCallback: (rect) {
        return const LinearGradient(
          begin: Alignment.center,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black,
            Colors.transparent,
          ],
        ).createShader(Rect.fromLTRB(
          0,
          0,
          rect.width,
          rect.height,
        ));
      },
      blendMode: BlendMode.dstIn,
      child: Image.asset(
        assetName,
        width: double.infinity,
        cacheWidth: 800,
      ),
    ),
    decoration: PageDecoration(
      titleTextStyle: Theme.of(context).textTheme.headline6!.copyWith(
            color: Colors.white,
          ),
      bodyFlex: height > 800 ? 6 : 4,
      imageFlex: height > 800 ? 3 : 3,
      imageAlignment: Alignment.topCenter,
      imagePadding: const EdgeInsets.only(
        left: 0,
        right: 0,
      ),
      contentMargin: const EdgeInsets.only(
        left: 0,
        right: 0,
      ),
    ),
  );
}
