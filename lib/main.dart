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
import 'package:global_strongman/widget_tree/onboarding_screen/view/main.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? _user;
  FirebaseUser? _firebaseUser;

  /// Checks if the user exist in the firestore db.
  Stream<DocumentSnapshot<Map<String, dynamic>>> getSignedInUserFromFireStore(
    User? user,
  ) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(user?.email)
          .snapshots();

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        if (user != null) {
          _user = user;
          setState(() {});
          Future.microtask(
            () => Provider.of<UserProvider>(context, listen: false)
                .updateAuthUser(user),
          );
        }
      },
    );

    getSignedInUserFromFireStore(FirebaseAuth.instance.currentUser).listen(
      (firebaseUserSnapshot) {
        if (firebaseUserSnapshot.exists) {
          final FirebaseUser firebaseUser =
              FirebaseUser.fromJson(firebaseUserSnapshot.data()!);
          _firebaseUser = firebaseUser;
          setState(() {});
          if (_firebaseUser != null) {
            Future.microtask(
              () => Provider.of<UserProvider>(context, listen: false)
                  .updateFirebaseUser(firebaseUser),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_user != null && _firebaseUser != null) {
      return MyAppScreen(
        user: _user,
        firebaseUser: _firebaseUser,
      );
    }
    return const MyAppScreen(
      user: null,
      firebaseUser: null,
    );
  }
}

class MyAppScreen extends StatelessWidget {
  const MyAppScreen({
    Key? key,
    required this.user,
    required this.firebaseUser,
  }) : super(key: key);

  final User? user;
  final FirebaseUser? firebaseUser;

  Widget _buildHomePage() {
    if (user == null) {
      return const LoginPage();
    } else if (user != null && firebaseUser == null) {
      return const OnBoarding();
    }
    return const BottomNavigator();
  }

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
        home: _buildHomePage(),
        material: (_, __) => MaterialAppData(
          theme: ThemeData(
            primaryColor: kPrimaryColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.grey.shade900,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[900],
            ),
            cardColor: Colors.grey[850],
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
// To full clean especially ios
// flutter clean        
// rm -Rf ios/Pods
// rm -Rf ios/.symlinks
// rm -Rf ios/Flutter/Flutter.framework
// rm -Rf ios/Flutter/Flutter.podspec