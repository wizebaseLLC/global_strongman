import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/widget_tree/onboarding/view/main.dart';
import 'package:page_transition/page_transition.dart';

class SignInController {
  SignInController({
    this.userController,
    this.passwordController,
  });

  TextEditingController? userController;
  TextEditingController? passwordController;

  Future<void> handleSignupFromEmail(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userController!.value.text,
        password: passwordController!.value.text,
      );

      if (userCredential.user != null) {
        await userCredential.user?.sendEmailVerification();

        Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeftWithFade,
              duration: const Duration(seconds: 1),
              child: const OnBoarding(),
            ));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showDialog(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showDialog(context, 'The account already exists for that email.');
      }
    } catch (e) {
      _showDialog(context, e.toString());
    }
  }

  void _showDialog(BuildContext context, String content) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: const Text(
          'Error',
          style: TextStyle(color: Colors.red),
        ),
        content: Text(content),
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
}
