import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ictv/screens/OnBoardingScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ictv/screens/SignInScreen.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// the log of the app
var logger = Logger(
  filter: null,
  printer: PrettyPrinter(),
  output: null,
);

var first_enter;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
        theme:
            ThemeData(brightness: Brightness.dark, primaryColor: Colors.white));
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pageLoad(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            child: first_enter ? SignIn() : OnboardingScreen(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

Future<bool> pageLoad() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  first_enter = prefs.get("first_enter");
  if (first_enter == null || !first_enter) {
    prefs.setBool("first_enter", true);
    first_enter = false;
    return true;
  }
  return true;
}
