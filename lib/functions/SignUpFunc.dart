import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../credentials.dart';

/*
  The Function try to sign up the user in the firebase auth system.
  input: {TextEditingController user, TextEditingController password, BuildContext context, TextEditingController name, Gender gender}
  return : 
*/

void signUp(user, password, context, name, gender) async {
  String emailS = user.text.trim();
  String passwordS = password.text;

  if (emailS.isEmpty || passwordS.isEmpty) {
    String title = "Email or Password Wrong";
    String alertext = "Enter the Details Again";
    String leftbuttom = "Cancel";
    String rightbuttom = "OK";
    popAlert(title, alertext, leftbuttom, rightbuttom, context);
  } else {
    try {
      // ignore: unused_local_variable
      final UserCredential userC = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: emailS, password: passwordS);

      DatabaseReference _reference = FirebaseDatabase.instance
          .reference()
          .child("Users" + "/" + userC.user.uid);

      Map<String, dynamic> userData = {
        "fullName": name.text,
        "Gender": gender.toString(),
        "Address": ""
      };

      _reference.set(userData);

      popAlert("Sign UP succeeded", "", "", "OK", context);
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

/*
  The Function Pops An Alert Dailog to present the messege and the buttoms according to the input. 
  input: {String title, String alertext, String leftbuttom, String rightbuttom, BuildContext context}
  return : 
*/

// ignore: missing_return
Future<void> popAlert(String title, String alertext, String leftbuttom,
    String rightbuttom, context) async {
  await showDialog(
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
                  locationIsUpdated = false;
                  Navigator.of(ctx).pop();
                },
                child: Text(leftbuttom)),
            FlatButton(
                onPressed: () {
                  locationIsUpdated = true;
                  Navigator.of(ctx).pop();
                },
                child: Text(rightbuttom))
          ],
        );
      });
}
