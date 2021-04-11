import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:ictv/functions/SignUpFunc.dart';
import 'package:ictv/screens/fiberSearch.dart';
import 'package:ictv/widgets/buildMenu.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import '../ColorsProject.dart';
import '../credentials.dart';
import '../main.dart';
import 'package:translator/translator.dart';

Map<dynamic, dynamic> toReturn;

// ignore: camel_case_types
class fiberView extends StatelessWidget {
  const fiberView({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return LiquidApp(
      materialApp: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ICTV',
          theme:
              ThemeData(brightness: Brightness.dark, accentColor: Colors.white),
          home: fiberchek()),
    );
  }
}

// ignore: camel_case_types
class fiberchek extends StatefulWidget {
  fiberchek({Key key}) : super(key: key);

  @override
  _fiberchekState createState() => _fiberchekState();
}

/*
  The internet infrastructure ratings page
*/

// ignore: camel_case_types
class _fiberchekState extends State<fiberchek> {
  @override
  void initState() {
    checkedLocation = false;
    super.initState();
  }

  Widget build(BuildContext context) {
    final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
    // ignore: unused_local_variable
    TextEditingController user = new TextEditingController();
    // ignore: unused_local_variable
    TextEditingController password = new TextEditingController();
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
                    logger.i("the user return to the fiberSearch ");
                    locationIsUpdated = false;
                    currCountry = "";
                    currAddress = "";
                    currCity = "";
                    Future.delayed(const Duration(milliseconds: 500), () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FiberTest()));
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
              FutureBuilder(
                future: fiberData(currCity, currAddress),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                              flex: 4,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  BorderedText(
                                      strokeWidth: 1.0,
                                      child: Text(
                                        'Fiber Test',
                                        style: TextStyle(
                                            shadows: <Shadow>[
                                              Shadow(
                                                offset: Offset(2, 2),
                                                blurRadius: 3.3,
                                                color: Colors.grey,
                                              ),
                                            ],
                                            fontSize: 55,
                                            color: primaryColor,
                                            decoration: TextDecoration.none,
                                            decorationColor: Colors.white),
                                      )),
                                ],
                              )),
                          Spacer(),
                          Flexible(
                            flex: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/loading.gif',
                                image:
                                    "https://media.giphy.com/media/Cc9vdxyEu2bJwgXbnT/giphy.gif",
                                fit: BoxFit.cover,
                                height: MediaQuery.of(context).size.height / 2,
                              ),
                            ),
                          ),
                        ]);
                  } else {
                    logger.i("fiberSearch Results Arrived ");
                    Map<dynamic, dynamic> currData = toReturn;
                    List<DataRow> rowsIn = new List();
                    currData.forEach((key, value) {
                      DataRow dateRow = DataRow(cells: [
                        DataCell(Row(
                          children: [
                            Spacer(),
                            Flexible(
                                flex: 3,
                                child: Column(
                                  children: [
                                    Spacer(),
                                    Flexible(
                                      flex: 6,
                                      child: key == "bezeq"
                                          ? Row(
                                              children: <Widget>[
                                                Spacer(
                                                  flex: 5,
                                                ),
                                                InkWell(
                                                  highlightColor: primaryColor,
                                                  child: Image.network(
                                                    Companies_lst[key],
                                                  ),
                                                ),
                                                Spacer(
                                                  flex: 11,
                                                )
                                              ],
                                            )
                                          : Row(
                                              children: <Widget>[
                                                InkWell(
                                                  highlightColor: primaryColor,
                                                  child: Image.network(
                                                    Companies_lst[key],
                                                  ),
                                                ),
                                                Spacer(
                                                  flex: 5,
                                                )
                                              ],
                                            ),
                                    ),
                                    Spacer()
                                  ],
                                )),
                          ],
                        )),
                        DataCell(Row(
                          children: <Widget>[
                            Spacer(),
                            ImageIcon(
                              AssetImage(Companies_fiber[value]),
                              size: 44.0,
                              color: Color(0xff3498db),
                            ),
                            Spacer()
                          ],
                        )),
                      ]);
                      rowsIn.add(dateRow);
                    });
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                              flex: 4,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  BorderedText(
                                      strokeWidth: 1.0,
                                      child: Text(
                                        'Fiber Test',
                                        style: TextStyle(
                                            shadows: <Shadow>[
                                              Shadow(
                                                offset: Offset(2, 2),
                                                blurRadius: 3.3,
                                                color: Colors.grey,
                                              ),
                                            ],
                                            fontSize: 55,
                                            color: primaryColor,
                                            decoration: TextDecoration.none,
                                            decorationColor: Colors.white),
                                      )),
                                ],
                              )),
                          Spacer(),
                          Flexible(
                              flex: 5,
                              child: DataTable(
                                  dividerThickness: 0.5,
                                  horizontalMargin: 42,
                                  headingRowHeight: 40,
                                  dataRowHeight: kMinInteractiveDimension + 15,
                                  columns: [
                                    DataColumn(
                                        label: BorderedText(
                                            strokeWidth: 1.0,
                                            child: Text(
                                              'Company',
                                              style: TextStyle(
                                                  shadows: <Shadow>[
                                                    Shadow(
                                                      offset: Offset(2, 2),
                                                      blurRadius: 3.3,
                                                      color: Colors.grey,
                                                    ),
                                                  ],
                                                  fontSize: 28,
                                                  color: primaryColor,
                                                  decoration:
                                                      TextDecoration.none,
                                                  decorationColor:
                                                      Colors.white),
                                            ))),
                                    DataColumn(
                                        label: BorderedText(
                                            strokeWidth: 1.0,
                                            child: Text(
                                              'Result',
                                              style: TextStyle(
                                                  shadows: <Shadow>[
                                                    Shadow(
                                                      offset: Offset(2, 2),
                                                      blurRadius: 3.3,
                                                      color: Colors.grey,
                                                    ),
                                                  ],
                                                  fontSize: 28,
                                                  color: primaryColor,
                                                  decoration:
                                                      TextDecoration.none,
                                                  decorationColor:
                                                      Colors.white),
                                            ))),
                                  ],
                                  rows: rowsIn)),
                        ]);
                  }
                },
              )
            ]),
          )),
    );
  }
}

Future<Map<dynamic, dynamic>> fiberData(String city, String address) async {
  // ignore: close_sinks
  Socket socket = await Socket.connect('87.68.185.255', 12000);
  final translator = GoogleTranslator();
  String cityHeb =
      (await translator.translate(city, from: 'en', to: 'iw')).text;

  socket.add(utf8.encode(cityHeb + "," + address));
  return socket.listen((data) {
    toReturn = json.decode(utf8.decode(data));
  }).asFuture();
}
