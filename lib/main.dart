import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/providers/badge_current_values.dart';
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
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        title: 'Flutter Platform Widgets',
        home: const LoginPage(),
        material: (_, __) => MaterialAppData(
          theme: ThemeData(
            primaryColor: kPrimaryColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            brightness: Brightness.dark,
          ),
        ),
        cupertino: (_, __) => CupertinoAppData(
          theme: const CupertinoThemeData(
            primaryColor: kPrimaryColor,
            brightness: Brightness.dark,
          ),
        ),
      ),
    );
  }
}
