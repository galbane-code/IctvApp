import 'package:flutter/material.dart';
import 'package:ictv/ColorsProject.dart';
import 'package:ictv/functions/connection.dart';
import 'package:ictv/screens/CompanieScreen.dart';
import 'package:ictv/screens/SignInScreen.dart';
import 'package:ictv/screens/locationScreen.dart';
import 'package:ictv/screens/signUpPage.dart';
import 'package:ictv/widgets/GenderSelector.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:toast/toast.dart';
import '../credentials.dart';
import '../main.dart';

/*
  The widget that build the side menu of the app,
  and enables the user to change page to his desired page   
*/

Widget buildMenu(context, _sideMenuKey) {
  String userName;
  String picturePath;
  if (userCredential == null) {
    userName = "Anyonymos";
  } else {
    if (userData != null) {
      userName = userData["fullName"];
      if (userData["Gender"] == Gender.FEMALE.toString()) {
        picturePath = "assets/user_logo_female.png";
      } else {
        picturePath = "assets/user_logo.png";
      }
    } else {
      userName = userCredential.user.displayName;
    }
  }
  if (picturePath == null) {
    picturePath = "assets/user_logo.png";
  }

  final GlobalKey<SideMenuState> sidemenu = _sideMenuKey;
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(vertical: 50.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              Row(
                children: [
                  Flexible(
                    flex: 4,
                    child: LText(
                      "\l.lead{Hello},\n\l.lead.bold{$userName}",
                      baseStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  Spacer(),
                  Flexible(
                    flex: 2,
                    child: Image(
                      image: AssetImage(picturePath),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
        LListItem(
          backgroundColor: Colors.transparent,
          onTap: () {
            final _state = sidemenu.currentState;
            _state.closeSideMenu();
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignIn()));
            });
          },
          leading: Icon(Icons.home, size: 20.0, color: primaryColor),
          title: Text("Sign In"),
          textColor: Colors.black,
          dense: true,
        ),
        LListItem(
          backgroundColor: Colors.transparent,
          onTap: () {
            final _state = sidemenu.currentState;
            _state.closeSideMenu();
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignUp()));
            });
          },
          leading: Icon(Icons.account_circle_rounded,
              size: 20.0, color: primaryColor),
          title: Text("Sign Up"),
          textColor: Colors.black,
          dense: true,

          // padding: EdgeInsets.zero,
        ),
        LListItem(
          backgroundColor: Colors.transparent,
          onTap: () async {
            final _state = sidemenu.currentState;
            _state.closeSideMenu();
            Future<bool> checkconn = check();
            bool connection = await checkconn;
            if (connection) {
              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LocationScreen()));
              });
            } else {
              logger.w(
                  "the user is try to connect but there is not internet connection");
              Toast.show("You need to connect to the intrenet first", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            }
          },
          leading:
              Icon(Icons.location_on_outlined, size: 20.0, color: primaryColor),
          title: Text("Pick Your Location"),
          textColor: Colors.black,
          dense: true,

          // padding: EdgeInsets.zero,
        ),
        LListItem(
          backgroundColor: Colors.transparent,
          onTap: () {
            final _state = sidemenu.currentState;
            _state.closeSideMenu();
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Companies()));
            });
          },
          leading: Icon(Icons.list_rounded, size: 20.0, color: primaryColor),
          title: Text("List Of Companies"),
          textColor: Colors.black,
          dense: true,

          // padding: EdgeInsets.zero,
        ),
      ],
    ),
  );
}
