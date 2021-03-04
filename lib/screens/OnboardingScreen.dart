import 'package:flutter/material.dart';
import 'package:ictv/ColorsProject.dart';
import 'package:ictv/screens/SignInScreen.dart';
import 'package:introduction_screen/introduction_screen.dart';

// ig'SignScreen.dart'utable
class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({Key key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

/*
  The First screen to show the users of the app the purpose of the app 
*/

class _OnboardingScreenState extends State<OnboardingScreen> {
  var pages = [
    PageViewModel(
        title: "welcome to ICTV",
        body:
            "The app that help you to pick the best internet,celluler and television company for you ",
        image: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(child: Image.asset("assets/screen11.png", height: 250.0)),
          ],
        ),
        decoration: const PageDecoration(
          pageColor: Colors.white,
          bodyTextStyle: TextStyle(color: Colors.black, fontSize: 20),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 30),
        )),
    PageViewModel(
        title: "How it Works",
        body:
            "The app takes into considerations the users ratings on each section, and also provides the recommendations accordingly ",
        image: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Center(child: Image.asset("assets/screen12.png", height: 250.0)),
          ],
        ),
        decoration: const PageDecoration(
          pageColor: Colors.white,
          bodyTextStyle: TextStyle(color: Colors.black, fontSize: 20),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 30),
        )),
    PageViewModel(
        title: "Also",
        body:
            "In the app you choose your location,so the recommendation will be specific for you. And enough talking lets go to work ",
        image: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Center(child: Image.asset("assets/screen13.png", height: 250.0)),
          ],
        ),
        decoration: const PageDecoration(
          pageColor: Colors.white,
          bodyTextStyle: TextStyle(color: Colors.black, fontSize: 20),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 30),
        ))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IntroductionScreen(
      pages: pages,
      onDone: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignIn()));
      },
      onSkip: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignIn()));
      },
      showSkipButton: true,
      skip: const Icon(
        Icons.skip_next,
        color: primaryColor,
        size: 35,
      ),
      next: const Icon(
        Icons.arrow_right,
        color: primaryColor,
        size: 35,
      ),
      done: Text("Done",
          style: TextStyle(
              fontWeight: FontWeight.w600, color: primaryColor, fontSize: 25)),
      dotsDecorator: DotsDecorator(
          size: const Size.square(20.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: primaryColor,
          color: Colors.grey,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
    ));
  }
}
