import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ictv/widgets/PopAlert.dart';

Future<UserCredential> signIn(user, password, context, userc) async {
  String emailS = user.text.trim();
  String passwordS = password.text;

  if (emailS.isEmpty || passwordS.isEmpty) {
    String title = "Email or Password Wrong";
    String alertext = "Enter the Details Again";
    String leftbuttom = "Cancel";
    String rightbuttom = "OK";
    PopAlert(title, alertext, leftbuttom, rightbuttom, context);
    return null;
  } else {
    try {
      userc = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailS, password: passwordS);
      return userc;
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text("Error"),
              content: Text(e.toString().substring(30)),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      return null;
                    },
                    child: Text("Cancel")),
                FlatButton(
                    onPressed: () {
                      emailS = "";
                      passwordS = "";
                      Navigator.of(ctx).pop();
                      return null;
                    },
                    child: Text("Ok"))
              ],
            );
          });
    }
    return null;
  }
}
