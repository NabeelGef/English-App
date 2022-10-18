import 'package:hive/hive.dart';
part 'englishWords.g.dart';

@HiveType(typeId: 0)
class EnglishWord {
  @HiveField(0)
  String English = "";
  @HiveField(1)
  String Arabic = "";
  EnglishWord({required this.English, required this.Arabic});
  getArabic() {
    return this.Arabic;
  }

  getEnglish() {
    return this.English;
  }

  EnglishWord.fromJson(Map<String, dynamic> json)
      : English = json['English'],
        Arabic = json['Arabic'];

  Map<String, dynamic> toJson() => {'English': English, 'Arabic': Arabic};
}
