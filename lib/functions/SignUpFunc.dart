import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void signUp(user, password, context) async {
  String emailS = user.text.trim();
  String passwordS = password.text;

  if (emailS.isEmpty || passwordS.isEmpty) {
    String title = "Email or Password Wrong";
    String alertext = "Enter the Details Again";
    String leftbuttom = "Cancel";
    String rightbuttom = "OK";
    PopAlert(title, alertext, leftbuttom, rightbuttom, context);
  } else {
    try {
      // ignore: unused_local_variable
      final UserCredential userC = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: emailS, password: passwordS);

      PopAlert("Sign UP succeeded", "", "", "OK", context);
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
                    },
                    child: Text("Cancel")),
                FlatButton(
                    onPressed: () {
                      emailS = "";
                      passwordS = "";
                      Navigator.of(ctx).pop();
                    },
                    child: Text("Ok"))
              ],
            );
          });
    }
  }
}

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
