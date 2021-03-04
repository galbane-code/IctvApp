import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ictv/screens/OnBoardingScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';

// the log of the app
var logger = Logger(
  filter: null,
  printer: PrettyPrinter(),
  output: null,
);

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
    return Container(
      child: OnboardingScreen(),
    );
  }
}
