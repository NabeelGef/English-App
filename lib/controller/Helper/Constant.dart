import 'package:hive_flutter/hive_flutter.dart';

import '../../models/englishWords.dart';

class Helper {
  final Box _box;

  Helper() : _box = Hive.box('Data');
  List<EnglishWord> getBox() {
    List? fromHive = _box.get('words');
    List<EnglishWord> english = [];
    if (fromHive != null) {
      for (EnglishWord i in fromHive) {
        //print("Data is : ===> ${i.Arabic} ===> ${i.English}");
        english.add(i);
      }
    }
    return english;
  }

  ClearData() {
    _box.clear();
  }

  AddData(List<EnglishWord> english) async {
    await _box.put("words", english);
  }

  // Future<Box<dynamic>> getBox() async {
  //   box = await Hive.openBox('Data');
  //   return box;
  // }

  // static List<EnglishWord> getListBox() {
  //   List<EnglishWord> english = Helper.box.get('words') as List<EnglishWord>;
  //   return english;
  // }
}
