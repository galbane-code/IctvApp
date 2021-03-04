import 'package:flutter/material.dart';

/*
  This widget is for the titles in the app    
*/

class GradientText extends StatelessWidget {
  GradientText(
    this.text, {
    @required this.gradient,
  });

  final String text;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        shaderCallback: (bounds) => gradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
        child: Text(text,
            style: TextStyle(
              fontStyle: FontStyle.normal,
              fontSize: 45,
              fontWeight: FontWeight.w900,
            )));
  }
}
