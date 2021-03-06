import 'dart:async';
import 'package:bordered_text/bordered_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_rating_bar/flutter_simple_rating_bar.dart';
import 'package:ictv/screens/rating_dialog.dart';
import 'package:ictv/widgets/companyPost.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:toast/toast.dart';
import '../ColorsProject.dart';
import '../credentials.dart';

Map<String, CompanyPost> companies = {
  "rami": CompanyPost(1.0, 1),
  "golan": CompanyPost(1.0, 1),
  "partner": CompanyPost(1.0, 1)
};

class CellularTab extends StatelessWidget {
  const CellularTab({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return LiquidApp(
      materialApp: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ICTV',
          theme:
              ThemeData(brightness: Brightness.dark, accentColor: Colors.white),
          home: Cellular()),
    );
  }
}

class Cellular extends StatefulWidget {
  Cellular({Key key}) : super(key: key);

  @override
  _CellularState createState() => _CellularState();
}

/*
  The cellular infrastructure ratings page
*/

class _CellularState extends State<Cellular> {
  @override
  Widget build(BuildContext context) {
    DatabaseReference _reference = FirebaseDatabase.instance
        .reference()
        .child("Cellular/" + currCountry + "/" + currCity + "/" + currAddress);

    Map<String, CompanyPost> companiesData = new Map();
    bool rate = locationIsUpdated && loggedIn;
    return FutureBuilder(
      future: CompanyPost.allCompanyPost(_reference, companies.keys.toList()),
      builder: (BuildContext context,
          AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
        List<DataRow> rowsIn = new List();
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            double tempRanking;
            int tempPeopleRanked;
            Map<dynamic, dynamic> currData = snapshot.data;
            currData.forEach((key, value) {
              Map<dynamic, dynamic> companyPostMap = value;
              var rank = companyPostMap["Ranking"];
              tempRanking = rank.toDouble();
              tempPeopleRanked = companyPostMap["PeopleRanked"];
              companiesData[key] = CompanyPost(tempRanking, tempPeopleRanked);
            });
          } else {
            companies.forEach((key, value) {
              _reference.child(key).set(value.toJson());
            });
            companiesData = companies;
          }
          companiesData.forEach((key, value) {
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
                            child: InkWell(
                              onTap: () async {
                                if (rate) {
                                  await rating(context, key, _reference,
                                          companiesData)
                                      .whenComplete(() => {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 400), () {
                                              if (!checkedLocation && rated) {
                                                Toast.show(
                                                    "Your Location is not near the Address",
                                                    context,
                                                    duration: Toast.LENGTH_LONG,
                                                    gravity: Toast.BOTTOM);
                                                rated = false;
                                              }
                                            }),
                                          });
                                  _reference.onValue.listen((event) {
                                    setState(() {});
                                  });
                                } else {
                                  if (loggedIn) {
                                    Toast.show(
                                        "Your Address Does Not Match The Current Address",
                                        context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                  } else {
                                    Toast.show(
                                        "You Need To Log In First", context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                  }
                                }
                              },
                              child: Image.network(
                                Companies_lst[key],
                              ),
                            ),
                          ),
                          Spacer()
                        ],
                      )),
                ],
              )),
              DataCell(RatingBar(
                rating: value.ranking,
                icon: Icon(
                  Icons.star,
                  size: 28,
                  color: Colors.grey,
                ),
                starCount: 5,
                spacing: 2.0,
                size: 20,
                isIndicator: true,
                allowHalfRating: true,
                color: primaryColor,
              )),
            ]);
            rowsIn.add(dateRow);
          });
        } else {
          companies.forEach((key, value) {
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
                            child: Image.network(
                              Companies_lst[key],
                            ),
                          ),
                          Spacer(
                            flex: 4,
                          )
                        ],
                      )),
                ],
              )),
              DataCell(CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
              )),
            ]);
            rowsIn.add(dateRow);
          });
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Spacer(
              flex: 1,
            ),
            Flexible(
              child: DataTable(
                  headingRowHeight: 80,
                  columnSpacing: 44.0,
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
                                      offset: Offset(1.5, 1.5),
                                      blurRadius: 2.2,
                                      color: Colors.black,
                                    ),
                                  ],
                                  fontSize: 33,
                                  color: primaryColor,
                                  decoration: TextDecoration.none,
                                  decorationColor: Colors.white),
                            ))),
                    DataColumn(
                        label: BorderedText(
                            strokeWidth: 1.0,
                            child: Text(
                              'Ranking',
                              style: TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(1.5, 1.5),
                                      blurRadius: 2.2,
                                      color: Colors.black,
                                    ),
                                  ],
                                  fontSize: 33,
                                  color: primaryColor,
                                  decoration: TextDecoration.none,
                                  decorationColor: Colors.white),
                            ))),
                  ],
                  rows: rowsIn),
              flex: 8,
            ),
          ],
        );
      },
    );
  }
}
