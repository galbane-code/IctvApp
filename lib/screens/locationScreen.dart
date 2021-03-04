import 'dart:async';
import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ictv/ColorsProject.dart';
import 'package:ictv/functions/SignUpFunc.dart';
import 'package:ictv/screens/ictvScreen.dart';
import 'package:ictv/widgets/Location.dart';
import 'package:ictv/widgets/PopAlert.dart';
import 'package:ictv/widgets/RaisedGradientButton.dart';
import 'package:ictv/widgets/buildMenu.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:dio/dio.dart';
import 'package:ictv/credentials.dart';
import 'package:geocoder/geocoder.dart';

import '../main.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return LiquidApp(
      materialApp: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ICTV',
          theme:
              ThemeData(brightness: Brightness.dark, accentColor: Colors.white),
          home: Location()),
    );
  }
}

/*
  The Third screen that enables the users to choose the location 
  they wish to see the rating of the ictv there.  
*/

// ignore: must_be_immutable
class Location extends StatefulWidget {
  Location({Key key}) : super(key: key);
  bool _choosenPlace = false;

  int indexWidget = -9;
  bool turnOn = false;
  LocationWidget choosenPlace;

  List<LocationWidget> suggestions = [
    LocationWidget(Colors.black, "Israel", "Tel Aviv", "דיזנגוף"),
    LocationWidget(Colors.black, "Israel", "Tel Aviv", "הרברט סמואל"),
    LocationWidget(Colors.black, "Israel", "Jerusalem", "בלפור"),
    LocationWidget(Colors.black, "Israel", "Be'er Sheva", "רגר"),
    LocationWidget(Colors.black, "Israel", "Ramat Gan", "אלכסנדר"),
    LocationWidget(Colors.black, "Israel", "Dimona", "הר מירון")
  ];

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  TextEditingController user = new TextEditingController();
  TextEditingController password = new TextEditingController();
  Timer timerMoney;
  bool timerbool = false;
  TextEditingController locationEditor = new TextEditingController();
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  var dictOfLocation = new HashMap();

  @override
  void initState() {
    super.initState();
    locationEditor.addListener(_onSearchChaned);
  }

  void dispose() {
    locationEditor.removeListener(_onSearchChaned);
    timerbool = true;
    locationEditor.dispose();
    super.dispose();
  }

  _onSearchChaned() {
    if (timerbool) {
      timerMoney.cancel();
    } else {
      timerMoney = Timer(const Duration(milliseconds: 50), () {
        getLocationResults(locationEditor.text);
      });
    }
  }

  void changeColorOne() {
    if (this.widget.turnOn) {
      for (var i = 0; i < this.widget.suggestions.length; i++) {
        String country = this.widget.suggestions[i].country;
        String city = this.widget.suggestions[i].city;
        String streetAndNumber = this.widget.suggestions[i].streetAndNumber;
        if (i == this.widget.indexWidget) {
          this.widget.suggestions[i] =
              LocationWidget(Colors.black, country, city, streetAndNumber);
        }
      }
    } else {
      for (var i = 0; i < this.widget.suggestions.length; i++) {
        String country = this.widget.suggestions[i].country;
        String city = this.widget.suggestions[i].city;
        String streetAndNumber = this.widget.suggestions[i].streetAndNumber;
        if (i == this.widget.indexWidget) {
          this.widget.suggestions[i] =
              LocationWidget(primaryColor, country, city, streetAndNumber);
        }
      }
    }
  }

  void getLocationResults(String text) async {
    if (text.isEmpty) {
      setState(() {});
    } else {
      String baseUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      String type = "address";
      String requset = '$baseUrl?input=$text&key=$PLACES_API&type=$type';
      Response response = await Dio().get(requset);
      final predictions = response.data['predictions'];

      this.widget.suggestions = new List<LocationWidget>();

      if (predictions == null || predictions.length == 0) {
        this.widget.suggestions = [
          LocationWidget(Colors.black, "Israel", "Tel Aviv", "דיזנגוף"),
          LocationWidget(Colors.black, "Israel", "Tel Aviv", "הרברט סמואל"),
          LocationWidget(Colors.black, "Israel", "Jerusalem", "בלפור"),
          LocationWidget(Colors.black, "Israel", "Be'er Sheva", "רגר"),
          LocationWidget(Colors.black, "Israel", "Ramat Gan", "אלכסנדר"),
          LocationWidget(Colors.black, "Israel", "Dimona", "הר מירון")
        ];
      } else {
        for (var i = 0; i < predictions.length && i < 6; i++) {
          String name = predictions[i]['description'];
          List<String> values = name.split(',');
          if (values.length != 3) {
            continue;
          }
          this.widget.suggestions.add(
              LocationWidget(Colors.black, values[2], values[1], values[0]));
        }
      }

      setState(() {});
    }
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Spacer(
                      flex: 3,
                    ),
                    Flexible(
                      flex: 3,
                      child: Row(
                        children: [
                          Flexible(
                            child: TextField(
                              maxLines: null,
                              expands: true,
                              keyboardType: TextInputType.emailAddress,
                              controller: locationEditor,
                              scrollPadding: EdgeInsets.only(top: 15),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19),
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.5),
                                  ),
                                  prefixIcon: Icon(Icons.search),
                                  alignLabelWithHint: true,
                                  labelText: "   Location Search",
                                  labelStyle: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black),
                                  hintStyle: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black),
                                  hintText: "Write Your Loaction Here"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Flexible(
                      flex: 15,
                      child: ListView.builder(
                          padding: EdgeInsets.only(
                              bottom: 18, top: 18, left: 2, right: 2),
                          itemCount: this.widget.suggestions.length > 6
                              ? 6
                              : this.widget.suggestions.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return InkWell(
                                child: this.widget.suggestions[index],
                                onTap: () {
                                  bool keyboardOn = MediaQuery.of(context)
                                          .viewInsets
                                          .bottom ==
                                      0;
                                  if (this.widget.turnOn && keyboardOn) {
                                    if (index == this.widget.indexWidget) {
                                      this.widget._choosenPlace = false;
                                      this.widget.indexWidget = index;
                                      changeColorOne();
                                      this.widget.choosenPlace =
                                          this.widget.suggestions[index];
                                      this.widget.turnOn = false;
                                      this.widget.indexWidget = -9;

                                      setState(() {});
                                    }
                                  } else {
                                    if (keyboardOn) {
                                      this.widget._choosenPlace = true;
                                      this.widget.indexWidget = index;
                                      changeColorOne();
                                      this.widget.choosenPlace = null;
                                      this.widget.turnOn = true;

                                      setState(() {});
                                    }
                                  }
                                });
                          }),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Flexible(
                      flex: 4,
                      child: this.widget._choosenPlace
                          ? Container(
                              child: AnimatedOpacity(
                                opacity: this.widget._choosenPlace ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 2500),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Spacer(),
                                    Flexible(
                                      flex: 3,
                                      child: RaisedGradientButton(
                                        child: Text(
                                          'Review Your ICTV',
                                          style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        gradient:
                                            LinearGradient(colors: <Color>[
                                          secondryColor,
                                          primaryColor,
                                          primaryColor,
                                          primaryColor,
                                          secondryColor,
                                        ]),
                                        onPressed: () async {
                                          currCountry = this
                                              .widget
                                              .suggestions[
                                                  this.widget.indexWidget]
                                              .country;
                                          currCity = this
                                              .widget
                                              .suggestions[
                                                  this.widget.indexWidget]
                                              .city;
                                          currAddress = this
                                              .widget
                                              .suggestions[
                                                  this.widget.indexWidget]
                                              .streetAndNumber;

                                          String query = currCountry +
                                              "," +
                                              currCity +
                                              "," +
                                              currAddress;
                                          var addresses = await Geocoder.local
                                              .findAddressesFromQuery(query);
                                          coordinates =
                                              addresses.first.coordinates;

                                          if (loggedIn) {
                                            logger.i(
                                                "the user choose the location " +
                                                    currCountry +
                                                    "/" +
                                                    currCity +
                                                    "/" +
                                                    currAddress);
                                            if (userData["Address"] == "") {
                                              await popAlert(
                                                  "Choose Address",
                                                  "You Wish To Update This Address As Yours ?",
                                                  "No",
                                                  "Yes",
                                                  context);
                                              if (locationIsUpdated) {
                                                userData["Address"] =
                                                    currCountry +
                                                        "/" +
                                                        currCity +
                                                        "/" +
                                                        currAddress;
                                                DatabaseReference _reference =
                                                    FirebaseDatabase.instance
                                                        .reference()
                                                        .child("Users" +
                                                            "/" +
                                                            userCredential
                                                                .user.uid);
                                                _reference.set(userData);
                                              }
                                            } else {
                                              var addressArr =
                                                  userData["Address"]
                                                      .split('/');
                                              if (addressArr[0] !=
                                                      currCountry ||
                                                  addressArr[1] != currCity ||
                                                  addressArr[2] !=
                                                      currAddress) {
                                                await popAlert(
                                                    "Wrong Address",
                                                    "This Address Does Not Match Yours.\nYou Wish To Update This Address As Yours ?",
                                                    "No",
                                                    "Yes",
                                                    context);
                                                bool changeAddress =
                                                    locationIsUpdated;
                                                if (changeAddress) {
                                                  userData["Address"] =
                                                      currCountry +
                                                          "/" +
                                                          currCity +
                                                          "/" +
                                                          currAddress;
                                                  DatabaseReference _reference =
                                                      FirebaseDatabase.instance
                                                          .reference()
                                                          .child("Users" +
                                                              "/" +
                                                              userCredential
                                                                  .user.uid);
                                                  _reference.set(userData);
                                                  locationIsUpdated = true;
                                                } else {
                                                  locationIsUpdated = false;
                                                }
                                              }
                                            }
                                          }

                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ictvScreen()));
                                        },
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    ),
                    Spacer(flex: 1)
                  ],
                )
              ]))),
    );
  }
}
