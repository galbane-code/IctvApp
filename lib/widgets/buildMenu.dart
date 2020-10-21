import 'package:flutter/material.dart';
import 'package:ictv/screens/CompanieScreen.dart';
import 'package:ictv/screens/SignInScreen.dart';
import 'package:ictv/screens/locationScreen.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

Widget buildMenu(String userName, context, _sideMenuKey) {
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
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 22.0,
              ),
              SizedBox(height: 16.0),
              LText(
                "\l.lead{Hello},\n\l.lead.bold{$userName}",
                baseStyle: TextStyle(color: Colors.white),
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
            Future.delayed(const Duration(milliseconds: 700), () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignIn()));
            });
          },
          leading: Icon(Icons.home, size: 20.0, color: Colors.white),
          title: Text("Home"),
          textColor: Colors.white,
          dense: true,
        ),
        LListItem(
          backgroundColor: Colors.transparent,
          onTap: () {},
          leading: Icon(Icons.verified_user, size: 20.0, color: Colors.white),
          title: Text("Profile"),
          textColor: Colors.white,
          dense: true,

          // padding: EdgeInsets.zero,
        ),
        LListItem(
          backgroundColor: Colors.transparent,
          onTap: () {
            final _state = sidemenu.currentState;
            _state.closeSideMenu();
            Future.delayed(const Duration(milliseconds: 700), () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => locationScreen(userName)));
            });
          },
          leading:
              Icon(Icons.location_on_outlined, size: 20.0, color: Colors.white),
          title: Text("Pick Your Location"),
          textColor: Colors.white,
          dense: true,

          // padding: EdgeInsets.zero,
        ),
        LListItem(
          backgroundColor: Colors.transparent,
          onTap: () {
            final _state = sidemenu.currentState;
            _state.closeSideMenu();
            Future.delayed(const Duration(milliseconds: 700), () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Companies(userName)));
            });
          },
          leading: Icon(Icons.list_rounded, size: 20.0, color: Colors.white),
          title: Text("List Of Companies"),
          textColor: Colors.white,
          dense: true,

          // padding: EdgeInsets.zero,
        ),
        LListItem(
          backgroundColor: Colors.transparent,
          onTap: () {},
          leading: Icon(Icons.settings, size: 20.0, color: Colors.white),
          title: Text("Settings"),
          textColor: Colors.white,
          dense: true,

          // padding: EdgeInsets.zero,
        ),
      ],
    ),
  );
}
