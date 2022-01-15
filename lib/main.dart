import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/core/providers/badge_current_values.dart';
import 'package:global_strongman/core/providers/firebase_instance_tools_provider.dart';
import 'package:global_strongman/core/providers/user_provider.dart';
import 'package:global_strongman/widget_tree/bottom_navigator/view/main.dart';
import 'package:global_strongman/widget_tree/login_screen/view/main.dart';
import 'package:provider/provider.dart';

import 'core/providers/activity_interace_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BadgeCurrentValues()..runSetMetrics(),
        ),
        ChangeNotifierProvider(
          create: (_) => ActivityInterfaceProvider()..createWorkoutInterface(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FirebaseInstanceToolsProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  /// Checks if the user exist in the firestore db.
  Future<DocumentSnapshot<Map<String, dynamic>>> getSignedInUserFromFireStore(
          User user) =>
      FirebaseFirestore.instance.collection('users').doc(user.email).get();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authUserSnapshot) {
          final User? user = authUserSnapshot.data;

          if (user == null) {
            return MyAppScreen(
              user: null,
              firebaseUser: null,
              isLoading:
                  authUserSnapshot.connectionState == ConnectionState.waiting,
            );
          }

          return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: getSignedInUserFromFireStore(user),
            builder: (context, firebaseUserSnapshot) {
              FirebaseUser? firebaseUser;
              final bool isLoading =
                  authUserSnapshot.connectionState == ConnectionState.waiting ||
                      firebaseUserSnapshot.connectionState ==
                          ConnectionState.waiting;

              if (firebaseUserSnapshot.data != null &&
                  firebaseUserSnapshot.data!.exists) {
                firebaseUser =
                    FirebaseUser.fromJson(firebaseUserSnapshot.data!.data()!);
              }

              return MyAppScreen(
                user: user,
                firebaseUser: firebaseUser,
                isLoading: isLoading,
              );
            },
          );
        });
  }
}

class MyAppScreen extends StatelessWidget {
  const MyAppScreen({
    Key? key,
    required this.user,
    required this.firebaseUser,
    required this.isLoading,
  }) : super(key: key);

  final User? user;
  final FirebaseUser? firebaseUser;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return PlatformProvider(
      settings: PlatformSettingsData(
        iosUsesMaterialWidgets: true,
      ),
      builder: (context) => PlatformApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],
        title: 'Global Strongman',
        home: isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : user == null || firebaseUser == null
                ? const LoginPage()
                : const BottomNavigator(),
        material: (_, __) => MaterialAppData(
          theme: ThemeData(
            primaryColor: kPrimaryColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            brightness: Brightness.dark,
          ),
        ),
        cupertino: (_, __) => CupertinoAppData(
          theme: const CupertinoThemeData(
            // This primary color is far too dark.
            // primaryColor: kPrimaryColor,
            brightness: Brightness.dark,
          ),
        ),
      ),
    );
  }
}
