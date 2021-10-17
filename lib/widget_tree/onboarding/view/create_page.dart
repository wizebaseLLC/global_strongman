import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:introduction_screen/introduction_screen.dart';

PageViewModel createPage({required BuildContext context, required Color backgroundColor, required String assetName, required List<Widget> body}) {
  var height = MediaQuery.of(context).size.height;

  return PageViewModel(
    title: "",
    bodyWidget: Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
          color: platformThemeData(
            context,
            material: (data) => data.scaffoldBackgroundColor,
            cupertino: (data) => data.scaffoldBackgroundColor,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              spreadRadius: 1,
            )
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(100),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: body,
      ),
    ),
    image: Stack(children: [
      _buildBarbellIcons(top: 0, left: -25),
      _buildBarbellIcons(top: 0, right: -25),
      _buildBarbellIcons(top: 150, left: -25),
      _buildBarbellIcons(top: 150, right: -25),
      Image.asset(assetName),
    ]),
    decoration: PageDecoration(
      pageColor: backgroundColor,
      bodyFlex: height > 800 ? 5 : 1,
      imageFlex: height > 800 ? 4 : 1,
      titlePadding: const EdgeInsets.all(0),
      imageAlignment: Alignment.bottomCenter,
      contentMargin: const EdgeInsets.only(
        left: 0,
        right: 0,
      ),
    ),
  );
}

Positioned _buildBarbellIcons({
  double? top,
  double? left,
  double? right,
  double? bottom,
}) {
  var angle = Random().nextInt(360).toDouble();
  return Positioned(
    top: top,
    left: left,
    right: right,
    bottom: bottom,
    child: Transform.rotate(
      angle: angle,
      child: Opacity(
        opacity: .3,
        child: Image.asset(
          "assets/images/barbell_icon.png",
          height: 120,
        ),
      ),
    ),
  );
}
