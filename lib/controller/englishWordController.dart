import 'dart:convert';

import 'package:english_app/controller/Helper/Constant.dart';
import 'package:english_app/models/englishWords.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
part 'englishWordController.g.dart';

@HiveType(typeId: 1)
class EnglishWordController extends GetxController {
  @HiveField(0)
  List<EnglishWord> englishwords = [];
  Helper helper = Helper();
  addWordsToList(EnglishWord englishWord) {
    englishwords = helper.getBox();
    englishwords.insert(0, englishWord);
    update();
  }
}
