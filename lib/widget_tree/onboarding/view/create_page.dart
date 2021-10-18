import 'package:flutter/material.dart';
import 'package:global_strongman/widget_tree/onboarding/view/barbell_icon.dart';
import 'package:introduction_screen/introduction_screen.dart';

/// Returns a [PageViewModel]
///
/// This includes the [backgroundColor], the image ([assetName]), and the [body]
PageViewModel createPage({
  required BuildContext context,
  required Color backgroundColor,
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
    image: Stack(children: [
      const BarbellIcon(top: 0, left: -25),
      const BarbellIcon(top: 0, right: -25),
      const BarbellIcon(top: 150, left: -25),
      const BarbellIcon(top: 150, right: -25),
      Image.asset(assetName),
    ]),
    decoration: PageDecoration(
      titleTextStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      pageColor: backgroundColor,
      bodyFlex: height > 800 ? 5 : 1,
      imageFlex: height > 800 ? 4 : 1,
      imageAlignment: Alignment.bottomCenter,
      contentMargin: const EdgeInsets.only(
        left: 0,
        right: 0,
      ),
    ),
  );
}
