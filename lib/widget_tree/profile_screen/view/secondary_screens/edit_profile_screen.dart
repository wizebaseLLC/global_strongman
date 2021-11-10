import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/firebase_user.dart';
import 'package:global_strongman/widget_tree/login_screen/controller/sign_in_controller.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/view/page2/main.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/view/page3/main.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/view/page4/main.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    required this.firebaseUser,
    Key? key,
  }) : super(key: key);

  final FirebaseUser firebaseUser;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool saving = false;
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      backgroundColor: platformThemeData(
        context,
        material: (data) => data.scaffoldBackgroundColor,
        cupertino: (data) => data.barBackgroundColor,
      ),
      appBar: PlatformAppBar(
        title: const Text("Edit Profile"),
        trailingActions: [
          TextButton(
            child: const Text("Save"),
            onPressed: onDone(context, _formKey),
          ),
        ],
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: FormBuilder(
            key: _formKey,
            initialValue: widget.firebaseUser.toJson(),
            child: ModalProgressHUD(
              inAsyncCall: saving,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (Platform.isIOS)
                      Padding(
                        padding: const EdgeInsets.all(kSpacing),
                        child: Text("Edit Profile",
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .navLargeTitleTextStyle),
                      ),
                    ...page2Body(
                      context: context,
                      shouldShowAvatar: false,
                      firebaseUser: widget.firebaseUser,
                    ),
                    ...page3Body(
                      context: context,
                      firebaseUser: widget.firebaseUser,
                    ),
                    ...page4Body(
                      context: context,
                      firebaseUser: widget.firebaseUser,
                    ),
                    const SizedBox(
                      height: kSpacing,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void Function() onDone(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return () {
      try {
        setState(() {
          saving = true;
        });
        if (formKey.currentState?.saveAndValidate() == true) {
          final Map<String, dynamic> formValues = formKey.currentState!.value;
          print(formValues);
          // SignInController().addUser(context, formValues).then((value) {
          //   setState(() {
          //     saving = false;
          //   });
          //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          // });
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
}
