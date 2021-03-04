import 'package:flutter/material.dart';
import 'package:ictv/ColorsProject.dart';

enum Gender { MALE, FEMALE, NONE }

/*
  This class reprsent the selection of the gender of the user in
  the sign up page to be set in the firebase database    
*/

// ignore: must_be_immutable
class GenderSelector extends StatefulWidget {
  String maletxt = "Male";
  String femaletxt = "Female";

  EdgeInsetsGeometry padding;
  EdgeInsetsGeometry margin;

  Gender selectedGender;

  ValueChanged<Gender> onChanged;

  GenderSelector(
      {this.maletxt = "Male",
      this.femaletxt = "Female",
      this.padding = const EdgeInsets.all(0),
      this.margin = const EdgeInsets.all(0),
      this.selectedGender,
      this.onChanged});

  @override
  _GenderSelectorState createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // male
          GestureDetector(
            onTap: () {
              setState(() {
                widget.selectedGender = Gender.MALE;
                widget.onChanged(widget.selectedGender);
              });
            },
            child: Container(
                child: Column(
              children: <Widget>[
                Container(
                  decoration: ShapeDecoration(
                      shape: CircleBorder(
                          side: BorderSide(
                              width: 4,
                              color: widget.selectedGender == Gender.MALE
                                  ? primaryColor
                                  : Colors.transparent))),
                  child: Image(
                    image: AssetImage("assets/user_logo.png"),
                    height: 50,
                    width: 50,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.maletxt,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ],
            )),
          ),

          // female
          GestureDetector(
            onTap: () {
              setState(() {
                widget.selectedGender = Gender.FEMALE;
                widget.onChanged(widget.selectedGender);
              });
            },
            child: Container(
                child: Column(
              children: <Widget>[
                Container(
                  decoration: ShapeDecoration(
                      shape: CircleBorder(
                          side: BorderSide(
                              width: 4,
                              color: widget.selectedGender == Gender.FEMALE
                                  ? primaryColor
                                  : Colors.transparent))),
                  child: Image(
                    image: AssetImage("assets/user_logo_female.png"),
                    height: 50,
                    width: 50,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.femaletxt,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
