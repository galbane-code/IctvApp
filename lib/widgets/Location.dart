import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/*
  This class is for the representation of the location in the 
  search location page .     
*/

class LocationWidget extends StatefulWidget {
  LocationWidget(
    this.color,
    this.country,
    this.city,
    this.streetAndNumber, {
    Key key,
  });

  final String country;
  final String city;
  final String streetAndNumber;
  final Color color;

  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
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
                widget.streetAndNumber,
                style: GoogleFonts.sansita(
                    color: this.widget.color,
                    fontWeight: FontWeight.w900,
                    fontSize: 25),
              )),
              Flexible(
                  child: Text(
                widget.country + "," + widget.city,
                style: GoogleFonts.sansita(
                    color: this.widget.color,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
              ))
            ],
          ),
        ),
        Flexible(
          flex: 4,
          child: Icon(
            Icons.location_on_sharp,
            size: 35,
            color: this.widget.color,
          ),
        )
      ],
    );
  }
}
