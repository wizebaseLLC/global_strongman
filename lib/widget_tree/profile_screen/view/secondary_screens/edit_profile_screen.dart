import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/core/view/platform_scaffold_ios_sliver_title.dart';
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
    return PlatformScaffoldIosSliverTitle(
      title: "Edit Profile",
      previousPageTitle: "My Profile",
      body: _buildBody(context),
      trailingActions: [
        _buildAppBarTextButton(context),
      ],
    );
  }

  Widget _buildAppBarTextButton(BuildContext context) {
    return PlatformTextButton(
      child: Text(
        "Save",
        style: TextStyle(
          color: Platform.isIOS ? CupertinoColors.activeBlue : Colors.blue,
        ),
      ),
      onPressed: () => saving ? null : onDone(context, _formKey),
      cupertino: (_, __) => CupertinoTextButtonData(
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      initialValue: widget.firebaseUser.toJson(),
      child: ModalProgressHUD(
        inAsyncCall: saving,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
    );
  }

  Future<void> onDone(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) async {
    try {
      setState(() {
        saving = true;
      });
      if (formKey.currentState?.saveAndValidate() == true) {
        final Map<String, dynamic> formValues = formKey.currentState!.value;
        Map<String, dynamic> copiedValues =
            Map<String, dynamic>.from(formValues);
        if (copiedValues["age"] != null && !Platform.isIOS) {
          copiedValues["age"] = int.tryParse(copiedValues["age"]);
        }
        final userEmail = FirebaseAuth.instance.currentUser?.email;

        if (userEmail != null) {
          await FirebaseUser(email: userEmail)
              .getDocumentReference()
              .update(copiedValues);
        }
        Navigator.pop(context);

        setState(() {
          saving = false;
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
      setState(
        () {
          saving = false;
        },
      );
    }
  }
}
