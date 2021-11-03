import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/login_page/controller/sign_in_with_apple.dart';
import 'package:global_strongman/widget_tree/login_page/controller/sign_in_with_facebook.dart';
import 'package:global_strongman/widget_tree/login_page/controller/sign_in_with_google.dart';
import 'package:global_strongman/widget_tree/onboarding/view/main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sign_button/constants.dart';

class SignInController {
  SignInController({
    this.userController,
    this.passwordController,
  });

  TextEditingController? userController;
  TextEditingController? passwordController;
  String forgotPasswordEmail = '';

  Future<void> handleSocialLogin({required ButtonType buttonType}) async {
    switch (buttonType) {
      case ButtonType.google:
        {
          await signInWithGoogle().catchError((e) => print(e));
        }
        break;

      case ButtonType.facebook:
        {
          await signInWithFacebook().catchError((e) => print(e));
        }
        break;

      case ButtonType.apple:
        {
          print("apple");
          await signInWithApple().catchError((e) => print(e));
        }
        break;

      default:
        {
          break;
        }
        break;
    }
  }

  Future<void> handleForgotPassword(BuildContext context) async {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: const Text(
          'Forgot Password?',
          style: TextStyle(color: Colors.blue),
        ),
        content: Column(
          children: [
            const SizedBox(height: kSpacing),
            const Text("Enter your accounts email address"),
            const SizedBox(height: kSpacing),
            PlatformTextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                forgotPasswordEmail = value;
              },
              autofocus: true,
            )
          ],
        ),
        actions: <Widget>[
          PlatformDialogAction(
            child: PlatformText(
              'Cancel',
              style: const TextStyle(color: Colors.blue),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          PlatformDialogAction(
            child: PlatformText(
              'Send',
              style: const TextStyle(color: Colors.blue),
            ),
            onPressed: () async {
              try {
                if (forgotPasswordEmail.length > 1) {
                  FirebaseAuth.instance.sendPasswordResetEmail(email: forgotPasswordEmail);
                  Navigator.pop(context);
                }
              } catch (e) {
                _showDialog(context, e.toString());
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

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

  Future<void> handleSignInFromEmail(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userController!.value.text,
        password: passwordController!.value.text,
      );

      if (userCredential.user != null) {
        Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeftWithFade,
              duration: const Duration(seconds: 1),
              child: const OnBoarding(), // TODO replace with main app component after login
            ));

        if (!userCredential.user!.emailVerified) {
          await userCredential.user?.sendEmailVerification();
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showDialog(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _showDialog(context, 'Wrong password provided for that user.');
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
