import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
void PopAlert(String title, String alertext, String leftbuttom,
    String rightbuttom, context) {
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(title),
          content: Text(alertext),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text(leftbuttom)),
            FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text(rightbuttom))
          ],
        );
      });
}
