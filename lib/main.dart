import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/widget_tree/onboarding/view/main.dart';

void main() {
  runApp(const MyApp());
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
        home: const OnBoarding(),
        material: (_, __) => MaterialAppData(
          theme: ThemeData(
            primaryColor: const Color(0xff1F26B7),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            brightness: Brightness.dark,
          ),
        ),
        cupertino: (_, __) => CupertinoAppData(
          theme: const CupertinoThemeData(
            primaryColor: Color(0xff1F26B7),
            brightness: Brightness.dark,
          ),
        ),
      ),
    );
  }
}
