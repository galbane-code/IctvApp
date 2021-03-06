import 'package:flutter/material.dart';
import 'package:ictv/ColorsProject.dart';

/*
  This widget is for the buttoms in the app    
*/

class RaisedGradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final Function onPressed;

  const RaisedGradientButton({
    Key key,
    @required this.child,
    this.gradient,
    this.width = double.infinity,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              offset: Offset(0.0, 1.5),
              blurRadius: 1.5,
            ),
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            borderRadius: BorderRadius.circular(18.0),
            highlightColor: primaryColor,
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}
