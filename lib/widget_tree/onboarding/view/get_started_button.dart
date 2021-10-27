import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:introduction_screen/introduction_screen.dart';

class GetStartedButton extends StatelessWidget {
  const GetStartedButton({
    Key? key,
    required this.controller,
    required this.backgroundColor,
  }) : super(key: key);

  final GlobalKey<IntroductionScreenState> controller;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: kSpacing,
        right: kSpacing,
      ),
      width: MediaQuery.of(context).size.width,
      child: PlatformButton(
        onPressed: () => {
          controller.currentState?.animateScroll(1),
        },
        child: PlatformText(
          'Get Started',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        material: (_, __) => MaterialRaisedButtonData(
            shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        )),
        cupertino: (_, __) => CupertinoButtonData(),
        color: backgroundColor,
      ),
    );
  }
}
