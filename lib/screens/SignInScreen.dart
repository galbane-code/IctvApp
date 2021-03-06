import 'dart:async';
import 'package:bordered_text/bordered_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ictv/functions/SignInFunc.dart';
import 'package:ictv/functions/SignUpFunc.dart';
import 'package:ictv/functions/connection.dart';
import 'package:ictv/widgets/PopAlert.dart';
import 'package:ictv/widgets/RaisedGradientButton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ictv/widgets/buildMenu.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:ictv/ColorsProject.dart';
import 'package:toast/toast.dart';
import '../credentials.dart';
import '../main.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }
bool _isObscure = true;
GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class SignIn extends StatelessWidget {
  const SignIn({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return LiquidApp(
      materialApp: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ICTV',
        theme:
            ThemeData(brightness: Brightness.dark, accentColor: Colors.white),
        home: SignInScreen(),
      ),
    );
  }
}

/*
  The Second screen that enables the users to log in to the app,
  the users can log in using firebase auth or google auth. 
*/

class SignInScreen extends StatefulWidget {
  SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  TextEditingController user = new TextEditingController();
  TextEditingController password = new TextEditingController();
  Future<UserCredential> userc;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String getStatus() {
      if (userCredential == null) {
        return "Disconnected";
      } else {
        return "Connected";
      }
    }

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
                                    " is logout from the app");
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Spacer(
                      flex: 9,
                    ),
                    Flexible(
                      flex: 17,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Spacer(),
                          Flexible(
                              flex: 7,
                              child: Image(
                                alignment: Alignment.center,
                                image: AssetImage("assets/test.png"),
                              )),
                          Spacer(flex: 3),
                          Flexible(
                              flex: 15,
                              child: BorderedText(
                                  strokeWidth: 1.0,
                                  child: Text(
                                    'I C TV',
                                    style: TextStyle(
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(1.5, 1.5),
                                            blurRadius: 2.2,
                                            color: Colors.black,
                                          ),
                                        ],
                                        fontSize: 45,
                                        color: primaryColor,
                                        decoration: TextDecoration.none,
                                        decorationColor: Colors.white),
                                  ))),
                          Spacer(
                            flex: 4,
                          ),
                          Flexible(
                              flex: 8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Flexible(
                                    child: FaIcon(
                                      FontAwesomeIcons.userAlt,
                                      color:
                                          loggedIn ? Colors.black : Colors.grey,
                                      size: 35,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      getStatus(),
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    Spacer(
                      flex: 5,
                    ),
                    Flexible(
                        flex: 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Spacer(),
                            Flexible(
                              flex: 7,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                alignment: Alignment.bottomRight,
                                child: TextField(
                                  maxLines: null,
                                  expands: true,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: user,
                                  scrollPadding: EdgeInsets.only(top: 15),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19),
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 2.5),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 2.5),
                                      ),
                                      alignLabelWithHint: true,
                                      border: OutlineInputBorder(),
                                      labelText: "Email",
                                      labelStyle: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          color: Colors.black),
                                      hintStyle: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          color: Colors.black),
                                      hintText: "Write Email Here"),
                                ),
                              ),
                            ),
                            Spacer()
                          ],
                        )),
                    Spacer(
                      flex: 1,
                    ),
                    Flexible(
                        flex: 9,
                        child: Row(
                          children: <Widget>[
                            Spacer(),
                            Flexible(
                              flex: 7,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  controller: password,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19),
                                  obscureText: _isObscure,
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isObscure
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (_isObscure) {
                                              _isObscure = false;
                                            } else {
                                              _isObscure = true;
                                            }
                                          });
                                        },
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 2.5),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 2.5),
                                      ),
                                      alignLabelWithHint: true,
                                      border: OutlineInputBorder(),
                                      labelText: "Password",
                                      labelStyle: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          color: Colors.black),
                                      hintStyle: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          color: Colors.black),
                                      hintText: "Write Password Here"),
                                ),
                              ),
                            ),
                            Spacer()
                          ],
                        )),
                    Spacer(
                      flex: 7,
                    ),
                    Flexible(
                        flex: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Spacer(
                              flex: 7,
                            ),
                            Flexible(
                              child: IconButton(
                                  icon: Icon(
                                    Icons.info_outline_rounded,
                                    size: 40,
                                    color: Colors.black,
                                  ),
                                  onPressed: null),
                            ),
                            Spacer(
                              flex: 1,
                            )
                          ],
                        )),
                    Spacer(
                      flex: 5,
                    ),
                    Flexible(
                        flex: 5,
                        child: Row(
                          children: <Widget>[
                            Spacer(),
                            Flexible(
                              flex: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                alignment: Alignment.centerLeft,
                                child: RaisedGradientButton(
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        Flexible(
                                          flex: 2,
                                          child: Column(
                                            children: <Widget>[
                                              Spacer(
                                                flex: 1,
                                              ),
                                              Flexible(
                                                flex: 5,
                                                child: Image(
                                                  image: AssetImage(
                                                      "assets/sign_in.png"),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                              Spacer(
                                                flex: 1,
                                              )
                                            ],
                                          ),
                                        ),
                                        Spacer(flex: 3),
                                        Flexible(
                                          flex: 6,
                                          child: Text(
                                            'Sign In',
                                            style: TextStyle(
                                                fontStyle: FontStyle.normal,
                                                color: Colors.grey[700],
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    gradient: LinearGradient(colors: <Color>[
                                      secondryColor,
                                      Colors.grey[200],
                                      Colors.grey[200],
                                      Colors.grey[200],
                                      secondryColor,
                                    ]),
                                    onPressed: () async {
                                      Future<bool> checkconn = check();
                                      bool connection = await checkconn;
                                      if (connection) {
                                        try {
                                          userc = signIn(
                                              user, password, context, userc);

                                          userCredential = await userc;
                                        } catch (error) {
                                          print(error);
                                        }
                                        if (userCredential != null) {
                                          popAlert("", "Sign in succeeded", "",
                                              "Ok", context);
                                          logger.i(user.text +
                                              " is connected to the app");
                                          loggedIn = true;
                                          Future.delayed(
                                              const Duration(
                                                  milliseconds: 1000), () {
                                            setState(() {});
                                          });
                                        }
                                      } else {
                                        Toast.show(
                                            "You need to connect to the intrenet first",
                                            context,
                                            duration: Toast.LENGTH_LONG,
                                            gravity: Toast.BOTTOM);
                                        logger.w(
                                            "the user is try to connect but there is not internet connection");
                                      }

                                      DatabaseReference _reference =
                                          FirebaseDatabase.instance
                                              .reference()
                                              .child("Users" +
                                                  "/" +
                                                  userCredential.user.uid);
                                      DataSnapshot dataSnapshot =
                                          await _reference.once();
                                      userData = dataSnapshot.value;

                                      user = new TextEditingController();
                                      password = new TextEditingController();

                                      setState(() {});
                                    }),
                              ),
                            ),
                            Spacer()
                          ],
                        )),
                    Spacer(
                      flex: 1,
                    ),
                    Flexible(
                        flex: 5,
                        child: Row(
                          children: <Widget>[
                            Spacer(),
                            Flexible(
                              flex: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: RaisedGradientButton(
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        Flexible(
                                          flex: 2,
                                          child: Column(
                                            children: <Widget>[
                                              Spacer(
                                                flex: 1,
                                              ),
                                              Flexible(
                                                flex: 5,
                                                child: Image(
                                                  image: AssetImage(
                                                      "assets/google.png"),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                              Spacer(
                                                flex: 1,
                                              )
                                            ],
                                          ),
                                        ),
                                        Spacer(flex: 2),
                                        Flexible(
                                          flex: 7,
                                          child: Text(
                                            'Google Sign In',
                                            style: TextStyle(
                                                fontStyle: FontStyle.normal,
                                                color: Colors.grey[700],
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    gradient: LinearGradient(colors: <Color>[
                                      secondryColor,
                                      Colors.grey[200],
                                      Colors.grey[200],
                                      Colors.grey[200],
                                      secondryColor,
                                    ]),
                                    onPressed: () async {
                                      Future<bool> checkconn = check();
                                      bool connection = await checkconn;
                                      if (connection) {
                                        try {
                                          userc = _handleSignIn();
                                          userCredential = await userc;
                                        } catch (error) {
                                          print(error);
                                        }
                                        if (userCredential != null) {
                                          popAlert("", "Sign in succeeded", "",
                                              "Ok", context);
                                          logger.i(
                                              userCredential.user.displayName +
                                                  " is connected to the app");
                                          loggedIn = true;
                                          userData = null;
                                          Future.delayed(
                                              const Duration(
                                                  milliseconds: 1000), () {
                                            setState(() {});
                                          });
                                        }
                                      } else {
                                        Toast.show(
                                            "You need to connect to the intrenet first",
                                            context,
                                            duration: Toast.LENGTH_LONG,
                                            gravity: Toast.BOTTOM);
                                        logger.w(
                                            "the user is try to connect but there is not internet connection");
                                      }

                                      user = new TextEditingController();
                                      password = new TextEditingController();
                                    }),
                              ),
                            ),
                            Spacer()
                          ],
                        )),
                    Spacer(
                      flex: 4,
                    )
                  ],
                )
              ]))),
    );
  }

  Future<UserCredential> _handleSignIn() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      userc = auth.signInWithCredential(credential);
      userCredential = await userc;
      return userc;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
