import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ictv/widgets/Location.dart';
import 'package:ictv/widgets/RaisedGradientButton.dart';
import 'package:ictv/widgets/buildMenu.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:dio/dio.dart';
import 'package:ictv/credentials.dart';
import 'package:geocoder/geocoder.dart';

// ignore: camel_case_types
class locationScreen extends StatelessWidget {
  // ignore: type_init_formals
  const locationScreen(String this.username, {Key key}) : super(key: key);
  final String username;

  Widget build(BuildContext context) {
    return LiquidApp(
      materialApp: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ICTV',
          theme:
              ThemeData(brightness: Brightness.dark, accentColor: Colors.white),
          home: Location(username)),
    );
  }
}

// ignore: camel_case_types
// ignore: must_be_immutable
class Location extends StatefulWidget {
  // ignore: type_init_formals
  Location(String this.username, {Key key}) : super(key: key);
  final String username;
  bool _choosenPlace = false;

  int indexWidget = -9;
  bool turnOn = false;
  LocationWidget choosenPlace;

  List<LocationWidget> suggestions = [
    LocationWidget(Colors.white, "ישראל", "תל אביב יפו", "דיזנגוף 45"),
    LocationWidget(Colors.white, "ישראל", "תל אביב יפו", "הרברט סמואל 10"),
    LocationWidget(Colors.white, "5 ישראל", "ירושלים", "בלפור"),
    LocationWidget(Colors.white, "ישראל", "באר שבע", "רגר 148"),
    LocationWidget(Colors.white, "ישראל", "רמת גן", "אלכסנדר"),
    LocationWidget(Colors.white, "ישראל", "דימונה", "הר מירון 5")
  ];

  @override
  _LocationState createState() => _LocationState();
}

// ignore: camel_case_types
class _LocationState extends State<Location> {
  Timer timerMoney;
  bool timerbool = false;
  TextEditingController locationEditor = new TextEditingController();
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

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
      timerMoney = Timer(const Duration(milliseconds: 500), () {
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
              LocationWidget(Colors.white, country, city, streetAndNumber);
        }
      }
    } else {
      for (var i = 0; i < this.widget.suggestions.length; i++) {
        String country = this.widget.suggestions[i].country;
        String city = this.widget.suggestions[i].city;
        String streetAndNumber = this.widget.suggestions[i].streetAndNumber;
        if (i == this.widget.indexWidget) {
          this.widget.suggestions[i] =
              LocationWidget(Colors.black, country, city, streetAndNumber);
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
        this.widget.suggestions = [];
      } else {
        for (var i = 0; i < predictions.length; i++) {
          final query = predictions[i]['description'];
          var addresses = await Geocoder.local.findAddressesFromQuery(query);
          var first = addresses.first;
          print("${first.featureName} : ${first.coordinates}");
          String name = predictions[i]['description'];
          List<String> values = name.split(',');
          this.widget.suggestions.add(
              LocationWidget(Colors.white, values[2], values[1], values[0]));
        }
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      menu: buildMenu(widget.username, context, _sideMenuKey),
      child: SideMenu(
          background: Color(0xffD1D1CC),
          key: _sideMenuKey,
          menu: buildMenu(widget.username, context, _sideMenuKey),
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
                  image: AssetImage("assets/locationBackground.jpg"),
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
                              style: GoogleFonts.sansita(
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
                                  labelStyle: GoogleFonts.indieFlower(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black),
                                  hintStyle: GoogleFonts.indieFlower(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black),
                                  hintText: "Write Your Loaction Here"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 15,
                      child: ListView.builder(
                          padding: EdgeInsets.only(
                              bottom: 18, top: 18, left: 2, right: 2),
                          itemCount: this.widget.suggestions.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return InkWell(
                                child: this.widget.suggestions[index],
                                onTap: () {
                                  if (this.widget.turnOn) {
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
                                    this.widget._choosenPlace = true;
                                    this.widget.indexWidget = index;
                                    changeColorOne();
                                    this.widget.choosenPlace = null;
                                    this.widget.turnOn = true;

                                    setState(() {});
                                  }
                                });
                          }),
                    ),
                    Flexible(
                      flex: 5,
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
                                          style: GoogleFonts.indieFlower(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        gradient:
                                            LinearGradient(colors: <Color>[
                                          Color(0xffD1D1CC),
                                          Colors.white70,
                                          Colors.white70,
                                          Colors.white70,
                                          Color(0xffD1D1CC),
                                        ]),
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
