import 'package:bordered_text/bordered_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ictv/functions/SignUpFunc.dart';
import 'package:ictv/functions/connection.dart';
import 'package:ictv/widgets/GenderSelector.dart';
import 'package:ictv/widgets/PopAlert.dart';
import 'package:ictv/widgets/RaisedGradientButton.dart';
import 'package:ictv/widgets/buildMenu.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:toast/toast.dart';
import '../ColorsProject.dart';
import '../credentials.dart';
import '../main.dart';

bool _isObscure = true;

class SignUp extends StatelessWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LiquidApp(
      materialApp: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ICTV',
          theme:
              ThemeData(brightness: Brightness.dark, accentColor: Colors.white),
          home: SignUpPage()),
    );
  }
}

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

/*
  The Third screen that enables the users to sign up to the fire base auth and use the app 
*/

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  TextEditingController user = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController userName = new TextEditingController();
  Future<UserCredential> userc;
  Gender userGender;
  FirebaseAuth auth = FirebaseAuth.instance;
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Spacer(
                      flex: 6,
                    ),
                    Flexible(
                      flex: 12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Spacer(
                            flex: 4,
                          ),
                          Flexible(
                              flex: 16,
                              child: BorderedText(
                                  strokeWidth: 1.0,
                                  child: Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 3.3,
                                            color: Colors.grey,
                                          ),
                                        ],
                                        fontSize: 42,
                                        color: primaryColor,
                                        decoration: TextDecoration.none,
                                        decorationColor: Colors.white),
                                  ))),
                          Spacer(
                            flex: 2,
                          ),
                          Flexible(
                            flex: 10,
                            child: Image(
                              image: AssetImage("assets/SignUp.png"),
                            ),
                          )
                        ],
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Flexible(
                        flex: 5,
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
                                      fontSize: 15),
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 2.5),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
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
                        flex: 5,
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
                                  obscureText: _isObscure,
                                  keyboardType: TextInputType.text,
                                  controller: password,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
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
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 2.5),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
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
                      flex: 1,
                    ),
                    Flexible(
                        flex: 5,
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
                                  controller: userName,
                                  scrollPadding: EdgeInsets.only(top: 15),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 2.5),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 2.5),
                                      ),
                                      alignLabelWithHint: true,
                                      border: OutlineInputBorder(),
                                      labelText: "Full Name",
                                      labelStyle: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          color: Colors.black),
                                      hintStyle: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          color: Colors.black),
                                      hintText: "Write Name Here"),
                                ),
                              ),
                            ),
                            Spacer()
                          ],
                        )),
                    Spacer(
                      flex: 2,
                    ),
                    Flexible(
                      flex: 9,
                      child: GenderSelector(
                        onChanged: (gender) {
                          userGender = gender;
                        },
                      ),
                    ),
                    Spacer(),
                    Flexible(
                        flex: 4,
                        child: Row(
                          children: <Widget>[
                            Spacer(),
                            Flexible(
                              flex: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(18),
                                      topRight: Radius.circular(18),
                                      bottomLeft: Radius.circular(18),
                                      bottomRight: Radius.circular(18)),
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
                                                      "assets/SignKey.png"),
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
                                          flex: 6,
                                          child: Text(
                                            'Sign Up',
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
                                        if (user.value.text.isNotEmpty &&
                                            password.value.text.isNotEmpty &&
                                            userName.value.text.isNotEmpty &&
                                            userGender != null) {
                                          signUp(user, password, context,
                                              userName, userGender);
                                          logger.i(userName.text +
                                              " signed up to the the system");
                                        } else {
                                          popAlert("", "Fill All The Details",
                                              "", "Ok", context);
                                          logger.i(
                                              "the user did not fill all the details to sign up");
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
                                      userName = new TextEditingController();
                                    }),
                              ),
                            ),
                            Spacer()
                          ],
                        )),
                    Spacer(
                      flex: 2,
                    )
                  ],
                )
              ]))),
    );
  }
}
