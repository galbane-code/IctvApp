import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ictv/ColorsProject.dart';
import 'package:ictv/functions/connection.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ictv/widgets/PopAlert.dart';
import 'package:ictv/widgets/buildMenu.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

import '../credentials.dart';
import '../main.dart';

class Companies extends StatelessWidget {
  Companies({Key key});

  @override
  Widget build(BuildContext context) {
    return LiquidApp(
      materialApp: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ICTV',
        theme:
            ThemeData(brightness: Brightness.dark, primaryColor: Colors.white),
        home: Companies_screen(),
      ),
    );
  }
}

/*
  The Fourth screen that enables the users to see the companies in 
  our app and the services that the company provides  
*/

// ignore: camel_case_types
class Companies_screen extends StatefulWidget {
  Companies_screen({Key key}) : super(key: key);

  @override
  _Companies_screenState createState() => _Companies_screenState();
}

// ignore: camel_case_types
class _Companies_screenState extends State<Companies_screen> {
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  final CarouselController _controller = CarouselController();
  int _current = 0;
  bool _visible = true;
  bool _visibleTwo = false;
  bool connected = true;
  List<String> imgList = [
    'https://www.malamteam.com/wp-content/uploads/2017/09/yes-logo.png',
    'https://upload.wikimedia.org/wikipedia/ru/4/4f/HOT_Logo.png',
    'https://upload.wikimedia.org/wikipedia/he/thumb/3/3f/Bezeq_logo.svg/442px-Bezeq_logo.svg.png',
    'https://www.leaderim.com/wp-content/uploads/2020/02/Partner-logo-2016.png',
    "https://img.wcdn.co.il/f_auto,w_1400,t_54/2/7/1/0/2710567-46.png",
    "https://simpel.co.il/wp-content/uploads/thumbs/ramilevilogo-page-ng9en8eixvujtxphsdx73333iuku47ovelkzqewhbg.png"
  ];

  var boolList = [
    [false, false, true],
    [true, false, true],
    [true, false, false],
    [true, true, true],
    [false, true, false],
    [false, true, false],
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    TextEditingController user = new TextEditingController();
    // ignore: unused_local_variable
    TextEditingController password = new TextEditingController();
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        FutureBuilder(
                            future: check(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                bool connection = snapshot.data;
                                connected = connection;
                                return InkWell(
                                  child: connection
                                      ? Image.network(item, fit: BoxFit.fill)
                                      : Container(
                                          alignment: Alignment.center,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 5.5,
                                            valueColor:
                                                new AlwaysStoppedAnimation<
                                                    Color>(primaryColor),
                                          ),
                                        ),
                                  onTap: () {
                                    if (_visibleTwo) {
                                      _visibleTwo = false;
                                    } else {
                                      _visibleTwo = true;
                                    }
                                    _visible = false;
                                    setState(() {});
                                  },
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            }),
                      ],
                    )),
              ),
            ))
        .toList();
    final List<Widget> buttoms = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Container(
                      width: 15.0,
                      height: 15.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == imgList.indexOf(item)
                              ? primaryColor
                              : Color.fromRGBO(0, 0, 0, 0.4)),
                    )),
              ),
            ))
        .toList();

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
                      Icons.menu,
                      color: primaryColor,
                    ),
                    onPressed: () {
                      final _state = _sideMenuKey.currentState;
                      if (_state.isOpened)
                        _state.closeSideMenu();
                      else
                        _state.openSideMenu();
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
                                PopAlert(
                                    "", "Log out succeeded", "", "Ok", context);
                                logger.i(userCredential.user.displayName +
                                    "is logout from the app");
                                loggedIn = false;
                                setState(() {});
                              } else {
                                PopAlert("", "Log in First", "", "Ok", context);
                                logger.i(
                                    "the user is try to logout but he did not logged in first");
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Spacer(flex: 4),
                    Flexible(
                        flex: 6,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BorderedText(
                                strokeWidth: 1.0,
                                child: Text(
                                  'Compaines Supported',
                                  style: TextStyle(
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(1.5, 1.5),
                                          blurRadius: 2.2,
                                          color: Colors.black,
                                        ),
                                      ],
                                      fontSize: 34,
                                      color: primaryColor,
                                      decoration: TextDecoration.none,
                                      decorationColor: Colors.white),
                                )),
                          ],
                        )),
                    Spacer(),
                    Flexible(
                        flex: 4,
                        child: AnimatedOpacity(
                          opacity: _visible ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 1500),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Press on to See \n What The Companies \n Utilities Supported Here",
                                style: GoogleFonts.sansita(
                                  color: Colors.grey,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              FaIcon(
                                FontAwesomeIcons.levelDownAlt,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ],
                          ),
                        )),
                    Spacer(flex: 2),
                    Flexible(
                      flex: 8,
                      child: CarouselSlider(
                        items: imageSliders,
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {
                            _visibleTwo = false;
                            _visible = true;
                            _current = index;
                            setState(() {});
                          },
                        ),
                        carouselController: _controller,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: buttoms),
                    ),
                    Spacer(),
                    Flexible(
                        flex: 3,
                        child: _visibleTwo
                            ? AnimatedOpacity(
                                opacity: _visibleTwo ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 2500),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FaIcon(
                                      FontAwesomeIcons.internetExplorer,
                                      color: boolList[_current][0]
                                          ? primaryColor
                                          : Colors.grey,
                                      size: 30,
                                    ),
                                    SizedBox(width: 15),
                                    FaIcon(
                                      FontAwesomeIcons.phone,
                                      color: boolList[_current][1]
                                          ? primaryColor
                                          : Colors.grey,
                                      size: 30,
                                    ),
                                    SizedBox(width: 15),
                                    FaIcon(
                                      FontAwesomeIcons.tv,
                                      color: boolList[_current][2]
                                          ? primaryColor
                                          : Colors.grey,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              )
                            : !connected
                                ? Container(
                                    child: BorderedText(
                                    strokeWidth: 1.0,
                                    child: Text(
                                      'No Internet Connection',
                                      style: TextStyle(
                                          shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(1.5, 1.5),
                                              blurRadius: 2.2,
                                              color: Colors.black,
                                            ),
                                          ],
                                          fontSize: 25,
                                          color: primaryColor,
                                          decoration: TextDecoration.none,
                                          decorationColor: Colors.white),
                                    ),
                                  ))
                                : Container())
                  ],
                ),
              ]))),
    );
  }
}
