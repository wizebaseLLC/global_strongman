import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/bottom_navigator/view/main.dart';
import 'package:global_strongman/widget_tree/login_screen/controller/sign_in_with_apple.dart';
import 'package:global_strongman/widget_tree/login_screen/controller/sign_in_with_facebook.dart';
import 'package:global_strongman/widget_tree/login_screen/controller/sign_in_with_google.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/view/main.dart';
import 'package:image_picker/image_picker.dart';
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
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> handleSocialLogin({
    required ButtonType buttonType,
    required BuildContext context,
  }) async {
    switch (buttonType) {
      case ButtonType.google:
        {
          try {
            await signInWithGoogle().catchError((e) => print(e));
            final firebaseUserExists = await getSignedInUserFromFireStore();
            if (firebaseUserExists) {
              Navigator.pushReplacement(
                  context,
                  platformPageRoute(
                      context: context,
                      builder: (context) => const BottomNavigator()));
            } else {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    duration: const Duration(seconds: 1),
                    child: const OnBoarding(),
                  ));
            }
          } catch (e) {
            showDialog(context, e.toString());
          }
        }
        break;

      case ButtonType.facebook:
        {
          try {
            await signInWithFacebook().catchError((e) => print(e));
            final firebaseUserExists = await getSignedInUserFromFireStore();
            if (firebaseUserExists) {
              Navigator.pushReplacement(
                  context,
                  platformPageRoute(
                      context: context,
                      builder: (context) => const BottomNavigator()));
            } else {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    duration: const Duration(seconds: 1),
                    child: const OnBoarding(),
                  ));
            }
          } catch (e) {
            showDialog(context, e.toString());
          }
        }
        break;

      case ButtonType.apple:
        {
          try {
            await signInWithApple().catchError((e) => print(e));
            final firebaseUserExists = await getSignedInUserFromFireStore();
            if (firebaseUserExists) {
              Navigator.pushReplacement(
                  context,
                  platformPageRoute(
                      context: context,
                      builder: (context) => const BottomNavigator()));
            } else {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    duration: const Duration(seconds: 1),
                    child: const OnBoarding(),
                  ));
            }
          } catch (e) {
            showDialog(context, e.toString());
          }
        }
        break;

      default:
        {
          break;
        }
        break;
    }
  }

  /// Checks if the user exist in the firestore db.
  Future<bool> getSignedInUserFromFireStore() async {
    try {
      final User? user = auth.currentUser;
      // Create a CollectionReference called users that references the firestore collection.
      DocumentSnapshot<Map<String, dynamic>> firestoreUser =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user?.email)
              .get();

      return firestoreUser.exists;
    } catch (e) {
      print(e);
      return false;
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
              textCapitalization: TextCapitalization.sentences,
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
                  FirebaseAuth.instance
                      .sendPasswordResetEmail(email: forgotPasswordEmail);
                  Navigator.pop(context);
                }
              } catch (e) {
                showDialog(context, e.toString());
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
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
        showDialog(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showDialog(context, 'The account already exists for that email.');
      }
    } catch (e) {
      showDialog(context, e.toString());
    }
  }

  Future<void> handleSignInFromEmail(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userController!.value.text,
        password: passwordController!.value.text,
      );

      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          platformPageRoute(
            context: context,
            builder: (context) => const BottomNavigator(),
          ),
        );

        if (!userCredential.user!.emailVerified) {
          await userCredential.user?.sendEmailVerification();
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialog(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showDialog(context, 'Wrong password provided for that user.');
      }
    } catch (e) {
      showDialog(context, e.toString());
    }
  }

  void showDialog(BuildContext context, String content) {
    try {
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
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> addUser(
      BuildContext context, Map<String, dynamic> values) async {
    try {
      // Create a CollectionReference called users that references the firestore collection.
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Extract the avatar file.
      XFile? avatar = values["avatar"];

      // Create a new mutable map from the form values.
      // This is required to update the download url and the email address.
      Map<String, dynamic> copiedValues = Map<String, dynamic>.from(values);

      // Get current user to extract email address.
      final User? user = auth.currentUser;

      if (user != null) {
        if (avatar != null) {
          // Upload the avatar image and gather its download url.
          final String? uploadedAvatarUrl = await addUserAvatarToStorage(
            context: context,
            email: user.email!,
            file: File(avatar.path),
          );

          // Add download url to the avatar value for the map.
          copiedValues["avatar"] = uploadedAvatarUrl;
        }
        copiedValues["email"] = user.email;
        // copiedValues["age"] = values["age"].toString();
        // Call the user's CollectionReference to add a new user
        await users.doc(user.email).set(copiedValues);
      }
    } catch (e) {
      showDialog(context, "Failed to add user: $e");
    }
  }

  Future<String?> addUserAvatarToStorage({
    required BuildContext context,
    required String email,
    required File file,
  }) async {
    try {
      final Reference ref =
          storage.ref("Users").child(email).child("/avatar.jpg");
      TaskSnapshot uploadTask = await ref.putFile(file);
      final url = await uploadTask.ref.getDownloadURL();
      return url;
    } catch (e) {
      showDialog(context, "Failed to upload image: $e");
    }
  }
}
