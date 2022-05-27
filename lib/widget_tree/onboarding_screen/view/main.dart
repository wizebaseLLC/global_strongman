import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/widget_tree/bottom_navigator/view/main.dart';
import 'package:global_strongman/widget_tree/login_screen/controller/sign_in_controller.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/model/list_page_data.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/view/create_page.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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

class OnboardForm extends StatefulWidget {
  const OnboardForm({
    Key? key,
    required GlobalKey<FormBuilderState> formKey,
    required this.introKey,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormBuilderState> _formKey;
  final GlobalKey<IntroductionScreenState> introKey;

  @override
  State<OnboardForm> createState() => _OnboardFormState();
}

class _OnboardFormState extends State<OnboardForm> {
  bool saving = false;

  void Function() onDone(
      BuildContext context, GlobalKey<FormBuilderState> formKey) {
    return () {
      try {
        setState(() {
          saving = true;
        });

        if (formKey.currentState?.saveAndValidate() == true) {
          Map<String, dynamic> formValues = {};
          formValues.addAll(formKey.currentState!.value);
          if (formValues['age'] is String) {
            formValues['age'] =
                int.tryParse(formValues["age"]) ?? formValues["age"];
          }
          //  print(formValues);
          SignInController().addUser(context, formValues).then((value) {
            setState(() {
              saving = false;
            });
            Navigator.pushReplacement(
              context,
              platformPageRoute(
                context: context,
                builder: (context) => const BottomNavigator(),
              ),
            );
          });
        } else {
          showPlatformDialog(
            context: context,
            builder: (_) => PlatformAlertDialog(
              title: const Text('Missing Required Fields'),
              content: const Text(
                  'Please go back and check for unanswered required fields'),
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
          setState(() {
            saving = false;
          });
        }
      } catch (e) {
        SignInController().showDialog(context, e.toString());
        setState(() {
          saving = false;
        });
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget._formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: ModalProgressHUD(
          inAsyncCall: saving,
          child: PlatformScaffold(
            cupertino: (context, platform) => CupertinoPageScaffoldData(
              resizeToAvoidBottomInset: false,
            ),
            body: IntroductionScreen(
              key: widget.introKey,
              pages: pageDataList(
                context: context,
                controller: widget.introKey,
                formKey: widget._formKey,
              )
                  .map(
                    (pageData) => createPage(
                      context: context,
                      assetName: pageData.imageUrl,
                      body: pageData.pageBody,
                      controller: widget.introKey,
                      title: pageData.title,
                    ),
                  )
                  .toList(),
              done: const Text(
                "Submit",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              next: const NextPageButton(),
              dotsContainerDecorator: const BoxDecoration(
                color: Colors.transparent,
              ),
              globalBackgroundColor: backgroundColor,
              dotsDecorator: DotsDecorator(
                size: const Size.square(10.0),
                activeSize: const Size(20.0, 10.0),
                activeColor: Colors.blue,
                color: Colors.white,
                spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onDone: onDone(context, widget._formKey),
            ),
          ),
        ),
      ),
    );
  }
}
