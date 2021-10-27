import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/onboarding/model/list_page_data.dart';
import 'package:global_strongman/widget_tree/onboarding/view/create_page.dart';
import 'package:global_strongman/widget_tree/onboarding/view/next_page_button.dart';
import 'package:introduction_screen/introduction_screen.dart';

/// Screen used to onboard a user.
///
/// Only visible until it is submitted once.
class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentIndex = 0;
  final introKey = GlobalKey<IntroductionScreenState>();
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    var activeColor = pageDataList(context: context, controller: introKey)[currentIndex].color;
    return PlatformScaffold(
      body: FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: IntroductionScreen(
            key: introKey,
            pages: pageDataList(context: context, controller: introKey)
                .map((pageData) => createPage(
                      context: context,
                      assetName: pageData.imageUrl,
                      backgroundColor: pageData.color,
                      body: pageData.pageBody,
                      controller: introKey,
                      title: pageData.title,
                    ))
                .toList(),
            done: const Text(
              "Submit",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            next: NextPageButton(activeColor: activeColor),
            onChange: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            dotsContainerDecorator: BoxDecoration(
              color: platformThemeData(
                context,
                material: (data) => data.scaffoldBackgroundColor,
                cupertino: (data) => data.primaryContrastingColor,
              ),
            ),
            controlsPadding: const EdgeInsets.all(0),
            globalBackgroundColor: backgroundColor,
            dotsDecorator: DotsDecorator(
                size: const Size.square(10.0),
                activeSize: const Size(20.0, 10.0),
                activeColor: kSecondaryColor,
                color: Colors.white,
                spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0))),
            onDone: () => print("done")),
      ),
    );
  }
}
