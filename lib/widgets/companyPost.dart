import 'package:firebase_database/firebase_database.dart';

/*
  This class reprsent the data of the ratings and helps us to insert 
  the data into the firebase database in a more comfortable way   
*/

class CompanyPost {
  double ranking;
  int peopleRanked;

  CompanyPost(this.ranking, this.peopleRanked);

  static Future<Map<dynamic, dynamic>> allCompanyPost(
      DatabaseReference databaseReference, List<String> companiesNames) async {
    Map<dynamic, dynamic> toReturn = new Map();
    DataSnapshot dataSnapshot = await databaseReference.once();

    if (dataSnapshot.value != null) {
      toReturn = dataSnapshot.value;
      return toReturn;
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {"Ranking": this.ranking, "PeopleRanked": this.peopleRanked};
  }
}
