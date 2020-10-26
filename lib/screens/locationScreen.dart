import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ictv/widgets/Location.dart';
import 'package:ictv/widgets/buildMenu.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:dio/dio.dart';
import 'package:ictv/credentials.dart';

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
class Location extends StatefulWidget {
  // ignore: type_init_formals
  Location(String this.username, {Key key}) : super(key: key);
  final String username;

  @override
  _LocationState createState() => _LocationState();
}

// ignore: camel_case_types
class _LocationState extends State<Location> {
  List<LocationWidget> suggestions = [
    LocationWidget("ישראל", "דימונה", "הר מירון 3"),
    LocationWidget("ישראל", "דימונה", "סחלבן החורש 53"),
    LocationWidget("ישראל", "רמת גן", "אלכסנדר 8"),
    LocationWidget("ישראל", "דימונה", "הר ארבל 3"),
    LocationWidget("ישראל", "דימונה", "הר נבו 3"),
    LocationWidget("ישראל", "דימונה", "הר מירון 3")
  ];

  TextEditingController locationEditor = new TextEditingController();
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

  @override
  void initState() {
    super.initState();
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
      suggestions = new List<LocationWidget>();

      for (var i = 0; i < predictions.length; i++) {
        String name = predictions[i]['description'];
        List<String> values = name.split(',');
        suggestions.add(LocationWidget(values[2], values[1], values[0]));
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
                              onChanged: (text) {
                                getLocationResults(text);
                              },
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
                                  labelText: "Location",
                                  labelStyle: GoogleFonts.indieFlower(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white),
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
                          itemCount: suggestions.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return suggestions[index];
                          }),
                    ),
                    Spacer(
                      flex: 5,
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
