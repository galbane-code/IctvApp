import 'package:flutter/material.dart';
import 'package:ictv/credentials.dart';
import 'package:ictv/functions/SignUpFunc.dart';
import 'package:ictv/screens/locationScreen.dart';
import 'package:ictv/widgets/buildMenu.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import '../ColorsProject.dart';
import '../main.dart';
import 'Internet.dart';
import 'Tv.dart';
import 'Cellular.dart';

// ignore: camel_case_types
class ictvScreen extends StatelessWidget {
  final String city;
  final String address;
  const ictvScreen({Key key, this.city, this.address}) : super(key: key);

  Widget build(BuildContext context) {
    return LiquidApp(
      materialApp: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ICTV',
          theme:
              ThemeData(brightness: Brightness.dark, accentColor: Colors.white),
          home: ictv(city: city, address: address)),
    );
  }
}

/*
  The main page of the app that create a menu of three pages one for each
  type of infrastructure : internet , cellular and television and retrive the ratings of the
  company that provides the infrastructure from the firebase real time database and allow the user
  to insert his own rating if he is passed the 2 step security off the app
*/

// ignore: camel_case_types
class ictv extends StatefulWidget {
  ictv({Key key, String city, String address}) : super(key: key);

  @override
  _ictvState createState() => _ictvState();
}

// ignore: camel_case_types
class _ictvState extends State<ictv> {
  @override
  void initState() {
    super.initState();
  }

  //Location location = new Location();
  TextEditingController user = new TextEditingController();
  TextEditingController password = new TextEditingController();
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  int _selectedIndex = 0;

  static var _pages = [InternetTab(), CellularTab(), TvTab()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      menu: buildMenu(context, _sideMenuKey),
      child: SideMenu(
          background: Colors.white,
          key: _sideMenuKey,
          menu: buildMenu(context, _sideMenuKey),
          type: SideMenuType.slideNRotate,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(40.0),
              child: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    logger.i(
                        "the user return to the location page and the address is deleted");
                    locationIsUpdated = false;
                    currCountry = "";
                    currAddress = "";
                    currCity = "";
                    Future.delayed(const Duration(milliseconds: 500), () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LocationScreen()));
                    });
                  },
                ),
                actions: <Widget>[
                  loggedIn
                      ? IconButton(
                          icon: Icon(
                            Icons.logout,
                            size: 23,
                            color: primaryColor,
                          ),
                          onPressed: () {
                            user = new TextEditingController();
                            password = new TextEditingController();
                            if (userCredential != null) {
                              userCredential = null;

                              setState(() {});
                              popAlert(
                                  "", "Log out succeeded", "", "Ok", context);
                              logger.i(
                                  "the user did not fill all the details to sign up");
                            } else {
                              popAlert("", "Log in First", "", "Ok", context);
                              logger.w(
                                  "the user is try to connect but there is not internet connection");
                            }
                          })
                      : Container(),
                ],
              ),
            ),
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomPadding: false,
            body: Stack(children: <Widget>[
              Image(
                image: AssetImage("assets/home_screen.jpg"),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
              _pages[_selectedIndex],
            ]),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.grey,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.wifi),
                  title: Text("Internet"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.phone),
                  title: Text("Cellular"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.tv),
                  title: Text("Tv"),
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: primaryColor,
              onTap: _onItemTapped,
            ),
          )),
    );
  }
}
