import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationWidget extends StatelessWidget {
  LocationWidget(
    this.country,
    this.city,
    this.streetAndNumber, {
    Key key,
  });

  final String country;
  final String city;
  final String streetAndNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                  child: Text(
                streetAndNumber,
                style: GoogleFonts.sansita(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 25),
              )),
              Flexible(
                  child: Text(
                country + "," + city,
                style: GoogleFonts.sansita(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
              ))
            ],
          ),
        ),
        Flexible(
          flex: 4,
          child: Icon(Icons.location_on_sharp, size: 35),
        )
      ],
    );
  }
}
