import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ictv/functions/SignInFunc.dart';
import 'package:ictv/functions/SignUpFunc.dart';
import 'package:ictv/widgets/RaisedGradientButton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ictv/widgets/GradientText.dart';
import 'package:ictv/widgets/buildMenu.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

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
            ThemeData(brightness: Brightness.dark, primaryColor: Colors.white),
        home: SignInScreen(),
      ),
    );
  }
}

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
  UserCredential userCredential;
  FirebaseAuth auth = FirebaseAuth.instance;
  double width, length;
  String userName = "Anonymous";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      if (userCredential == null) {
        return Colors.red[800];
      } else {
        return Colors.green[300];
      }
    }

    String getStatus() {
      if (userCredential == null) {
        return "Disconnected";
      } else {
        return "Connected";
      }
    }

    width = MediaQuery.of(context).size.width;
    length = MediaQuery.of(context).size.height;

    return SideMenu(
      menu: buildMenu(userName, context, _sideMenuKey),
      child: SideMenu(
          background: Color(0xffa0e1dd),
          key: _sideMenuKey,
          menu: buildMenu(userName, context, _sideMenuKey),
          type: SideMenuType.slideNRotate,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(40.0),
              child: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    final _state = _sideMenuKey.currentState;
                    if (_state.isOpened)
                      _state.closeSideMenu();
                    else
                      _state.openSideMenu();
                  },
                ),
              ),
            ),
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomPadding: false,
            body: Stack(
              children: <Widget>[
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
                    Flexible(
                      flex: 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Spacer(),
                          Flexible(
                              flex: 2,
                              child: Image(
                                alignment: Alignment.center,
                                image: AssetImage("assets/logo_foreground.png"),
                                height: length / 3,
                                width: width / 4,
                              )),
                          Spacer(flex: 1),
                          Flexible(
                            flex: 5,
                            child: GradientText("I C TV",
                                gradient: LinearGradient(colors: [
                                  Colors.blue[800],
                                  Colors.blue[700],
                                  Colors.red[400]
                                ])),
                          ),
                          Spacer(
                            flex: 2,
                          ),
                          Flexible(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Flexible(
                                    child: FaIcon(
                                      FontAwesomeIcons.userAlt,
                                      color: getColor(),
                                      size: 30,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      getStatus(),
                                      style: TextStyle(
                                          fontSize: 7,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )),
                          //Spacer()
                        ],
                      ),
                    ),
                    Spacer(),
                    Flexible(
                        flex: 22,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Spacer(flex: 4),
                            Flexible(
                              flex: 7,
                              child: Container(
                                alignment: Alignment.bottomRight,
                                child: TextField(
                                  maxLines: null,
                                  expands: true,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: user,
                                  scrollPadding: EdgeInsets.only(top: 15),
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.sansita(
                                      color: Colors.greenAccent[200],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19),
                                  decoration: InputDecoration(
                                      alignLabelWithHint: true,
                                      border: OutlineInputBorder(),
                                      labelText: "Email",
                                      labelStyle: GoogleFonts.indieFlower(
                                          color: Colors.black),
                                      hintStyle: GoogleFonts.indieFlower(
                                          color: Colors.black),
                                      hintText: "Write Email Here"),
                                ),
                              ),
                            ),
                            Spacer(flex: 4)
                          ],
                        )),
                    Spacer(),
                    Flexible(
                        flex: 22,
                        child: Row(
                          children: <Widget>[
                            Spacer(flex: 4),
                            Flexible(
                              flex: 7,
                              child: Container(
                                alignment: Alignment.center,
                                child: TextField(
                                  maxLines: null,
                                  expands: true,
                                  keyboardType: TextInputType.text,
                                  controller: password,
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.sansita(
                                      color: Colors.greenAccent[200],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Password",
                                      labelStyle: GoogleFonts.indieFlower(
                                          color: Colors.black),
                                      hintStyle: GoogleFonts.indieFlower(
                                          color: Colors.black),
                                      hintText: "Write Password Here"),
                                ),
                              ),
                            ),
                            Spacer(flex: 4)
                          ],
                        )),
                    Spacer(
                      flex: 5,
                    ),
                    Flexible(
                        flex: 24,
                        child: Row(
                          children: <Widget>[
                            Spacer(
                              flex: 7,
                            ),
                            Flexible(
                              flex: 5,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.info_outline_rounded,
                                    size: 40,
                                    color: Colors.red[800],
                                  ),
                                  onPressed: null),
                            ),
                            Spacer(flex: 4),
                            Flexible(
                                flex: 5,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        icon: Icon(
                                          Icons.logout,
                                          size: 30,
                                          color: Colors.red[800],
                                        ),
                                        onPressed: () {
                                          user = new TextEditingController();
                                          password =
                                              new TextEditingController();
                                          if (userCredential != null) {
                                            userc = null;
                                            userCredential = null;
                                            setState(() {});
                                            PopAlert("", "Log out succeeded",
                                                "", "Ok", context);
                                          } else {
                                            PopAlert("", "Log in First", "",
                                                "Ok", context);
                                          }
                                        }),
                                    Text(
                                      "Log Out",
                                      style: GoogleFonts.indieFlower(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                            Spacer(
                              flex: 3,
                            )
                          ],
                        )),
                    Spacer(
                      flex: 20,
                    ),
                    Flexible(
                        flex: 14,
                        child: Row(
                          children: <Widget>[
                            Spacer(),
                            Flexible(
                              flex: 4,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: RaisedGradientButton(
                                    child: Text(
                                      'Sign In',
                                      style: GoogleFonts.indieFlower(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    gradient: LinearGradient(colors: <Color>[
                                      Color(0xffa0e1dd),
                                      Colors.white70,
                                    ]),
                                    onPressed: () async {
                                      try {
                                        userc = signIn(
                                            user, password, context, userc);

                                        userCredential = await userc;
                                      } catch (error) {
                                        print(error);
                                      }
                                      if (userCredential != null) {
                                        PopAlert("", "Sign in succeeded", "",
                                            "Ok", context);
                                        Future.delayed(
                                            const Duration(milliseconds: 1000),
                                            () {
                                          setState(() {});
                                        });
                                      }
                                      userName =
                                          userCredential.user.displayName;
                                      user = new TextEditingController();
                                      password = new TextEditingController();
                                    }),
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: RaisedGradientButton(
                                    child: Text(
                                      'Sign Up',
                                      style: GoogleFonts.indieFlower(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    gradient: LinearGradient(colors: <Color>[
                                      Color(0xffa0e1dd),
                                      Colors.white70,
                                    ]),
                                    onPressed: () {
                                      signUp(user, password, context);
                                      user = new TextEditingController();
                                      password = new TextEditingController();
                                    }),
                              ),
                            ),
                            Spacer(),
                          ],
                        )),
                    Spacer(),
                    Flexible(
                        flex: 14,
                        child: Row(
                          children: <Widget>[
                            Spacer(),
                            Flexible(
                              flex: 8,
                              child: Container(
                                child: RaisedGradientButton(
                                    child: Text(
                                      'Google Sign In',
                                      style: GoogleFonts.indieFlower(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    gradient: LinearGradient(colors: <Color>[
                                      Color(0xffa0e1dd),
                                      Colors.white70,
                                    ]),
                                    onPressed: () async {
                                      try {
                                        userc = _handleSignIn();
                                        userCredential = await userc;
                                      } catch (error) {
                                        print(error);
                                      }
                                      if (userCredential != null) {
                                        PopAlert("", "Sign in succeeded", "",
                                            "Ok", context);
                                        Future.delayed(
                                            const Duration(milliseconds: 1000),
                                            () {
                                          setState(() {});
                                        });
                                      }
                                      userName =
                                          userCredential.user.displayName;
                                      user = new TextEditingController();
                                      password = new TextEditingController();
                                    }),
                              ),
                            ),
                            Spacer()
                          ],
                        ))
                  ],
                )
              ],
            ),
          )),
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
