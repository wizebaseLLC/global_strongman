import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/widget_tree/onboarding/model/list_page_data.dart';
import 'package:global_strongman/widget_tree/onboarding/view/create_page.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'next_page_button.dart';

/// Screen used to onboard a user.
///
/// Only visible until it is submitted once.
class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final introKey = GlobalKey<IntroductionScreenState>();

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: OnboardForm(
        formKey: _formKey,
        introKey: introKey,
      ),
    );
  }
}

class OnboardForm extends StatelessWidget {
  const OnboardForm({
    Key? key,
    required GlobalKey<FormBuilderState> formKey,
    required this.introKey,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormBuilderState> _formKey;
  final GlobalKey<IntroductionScreenState> introKey;

  static void Function() onDone(BuildContext context, GlobalKey<FormBuilderState> formKey) {
    return () {
      if (formKey.currentState?.saveAndValidate() == true) {
        print(formKey.currentState?.value);
      } else {
        showPlatformDialog(
          context: context,
          builder: (_) => PlatformAlertDialog(
            title: const Text('Missing Required Fields'),
            content: const Text('Please go back and check for unanswered required fields'),
            actions: <Widget>[
              PlatformDialogAction(
                child: PlatformText(
                  'Ok',
                  style: const TextStyle(color: Colors.blue),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () {
        _formKey.currentState?.save();
        print(_formKey.currentState?.value);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: IntroductionScreen(
            key: introKey,
            pages: pageDataList(
              context: context,
              controller: introKey,
              formKey: _formKey,
            )
                .map((pageData) => createPage(
                      context: context,
                      assetName: pageData.imageUrl,
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
            next: const NextPageButton(),
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
                activeColor: Colors.blue,
                color: Colors.white,
                spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0))),
            onDone: onDone(context, _formKey)),
      ),
    );
  }
}
