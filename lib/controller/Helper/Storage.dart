// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:shared_preferences/shared_preferences.dart';

import 'package:english_app/main.dart';

class Storage {
  static PutShowingSystemAlert(int show) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (show != 2) {
      sharedPreferences.setInt("show", show);
      print("Hello World!!!!!!!!!!!!!!!!!!!!");
    }
    print("Check In Class is : ${sharedPreferences.getInt("show")}");
    return sharedPreferences.getInt("show");
  }

  // static Future<bool?> getShowingSystemAlert() async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //   bool? check = sharedPreferences.getBool("show");
  //   print("Check In Getter is : $check");
  //   return check;
  // }
}
