import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/widget_tree/login_page/view/main.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FirebaseAuth _auth;
  User? _user;

  @override
  void initState() {
    Firebase.initializeApp().then((_) {
      setState(() {
        _auth = FirebaseAuth.instance;
      });
      _auth.idTokenChanges().listen((User? user) {
        if (user == null) {
          print("not signed in");
          setState(() {
            _user = null;
          });
        } else {
          setState(() {
            _user = user;
          });

          print(user);
        }
      });
    });
    super.initState();
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
        title: 'Flutter Platform Widgets',
        home: _user == null ? const LoginPage() : const LoginPage(),
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
