import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Location extends StatelessWidget {
  Location(
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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
                child: Text(
              country,
              style: GoogleFonts.sansita(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 25),
            )),
            Flexible(
                child: Text(
              city,
              style: GoogleFonts.sansita(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            )),
            Flexible(
                child: Text(
              streetAndNumber,
              style: GoogleFonts.sansita(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 25),
            ))
          ],
        ),
        Flexible(
          child: Icon(Icons.location_on_sharp),
        )
      ],
    );
  }
}
