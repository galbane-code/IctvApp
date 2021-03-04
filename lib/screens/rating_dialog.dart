import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ictv/ColorsProject.dart';
import 'package:ictv/credentials.dart';
import 'package:ictv/functions/position.dart';
import 'package:ictv/widgets/companyPost.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rating_dialog/rating_dialog.dart';
import '../main.dart';

/*
  The ratings pops up and enables the users to rate the company infrastructure in there address,
  and check if the user is near the address before the ratings in the database
*/

Future<dynamic> rating(context, String company, DatabaseReference _reference,
    Map<String, CompanyPost> companiesData) {
  return showDialog(
      context: context,
      barrierDismissible: true, // set to false if you want to force a rating
      builder: (context) {
        return RatingDialog(
          icon: ImageIcon(
            AssetImage("assets/test.png"),
            size: 100,
            color: primaryColor,
          ),
          title: "Rate " + company + " services",
          description: "Tap a star to set your rating.",
          submitButton: "SUBMIT",
          positiveComment: "We are so happy to hear :)", // optional
          negativeComment: "We're sad to hear :(", // optional
          accentColor: primaryColor, // optional
          onSubmitPressed: (int rating) async {
            // checks the locatin off the user

            if (await Permission.location.isGranted) {
              var currPosition = await determinePosition();
              var dist = Geolocator.distanceBetween(
                  currPosition.latitude,
                  currPosition.longitude,
                  coordinates.latitude,
                  coordinates.longitude);
              if (dist < 500) {
                checkedLocation = true;
              }
            }
            if (checkedLocation) {
              // update the rate in the database
              rated = true;
              double tempRanking = companiesData[company].ranking;
              int tempPeopleRanked = companiesData[company].peopleRanked;

              tempPeopleRanked = tempPeopleRanked + 1;
              tempRanking = (tempRanking + rating) / tempPeopleRanked;

              companiesData[company].ranking = tempRanking;
              companiesData[company].peopleRanked = tempPeopleRanked;

              companiesData.forEach((key, value) {
                _reference.child(key).update(value.toJson());

                logger.i("the user ranked the company " +
                    company +
                    " in the rating " +
                    rating.toString());
              });
            }
          },
        );
      });
}
