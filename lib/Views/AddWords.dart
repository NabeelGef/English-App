import 'dart:async';

import 'package:english_app/controller/englishWordController.dart';
import 'package:english_app/models/englishWords.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../controller/Helper/Constant.dart';

Helper helper = Helper();

class AddWords extends StatefulWidget {
  const AddWords({super.key});

  @override
  State<AddWords> createState() => _AddWordsState();
}

class _AddWordsState extends State<AddWords> {
  String AddAgain = "";
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    String English = "", Arabic = "";
    var englishControl = TextEditingController();
    var arabicControl = TextEditingController();
    GlobalKey<FormState> formstate = GlobalKey<FormState>();
    Future<bool> addWord(EnglishWordController englishWordController) async {
      if (formstate.currentState!.validate()) {
        formstate.currentState!.save();
        englishControl.clear();
        arabicControl.clear();
        EnglishWord englishWord = EnglishWord(Arabic: Arabic, English: English);
        englishWordController.addWordsToList(englishWord);
        helper.AddData(englishWordController.englishwords);
        for (EnglishWord i in helper.getBox()) {
          print("The All Data Added : ${i.English} <==> ${i.Arabic}");
        }
        return true;
      }
      return false;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Add Words")),
      body: GetBuilder(
        init: EnglishWordController(),
        builder: (controller) {
          return Form(
            key: formstate,
            child: Column(
              children: [
                TextFormField(
                  controller: englishControl,
                  enabled: !clicked,
                  onSaved: (newValue) {
                    English = newValue!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return " The Field is Empty!!";
                    } else if (value.length > 20) {
                      return "The Word is very Long !!";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(label: Text("English")),
                ),
                TextFormField(
                  controller: arabicControl,
                  enabled: !clicked,
                  onSaved: (newValue) {
                    Arabic = newValue!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return " The Field is Empty!!";
                    } else if (value.length > 20) {
                      return "The Word is very Long !!";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(label: Text("العربية")),
                ),
                Text(
                  "$AddAgain ",
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
                Center(
                  child: SizedBox(
                    width: 100,
                    child: MaterialButton(
                      color: Colors.amber,
                      onPressed: () async {
                        final service = FlutterBackgroundService();

                        if (!clicked && await addWord(controller)) {
                          setState(() {
                            clicked = true;
                            AddAgain = "Click Again Please!!";
                          });
                          service.invoke("close");
                          bool running = await service.isRunning();
                          print("Running Is : $running");
                          if (!running) {
                            service.startService();
                            running = await service.isRunning();
                            print("Running Is : $running");
                            if (running) {
                              Get.back();
                            }
                          }
                        } else if (clicked) {
                          service.invoke("close");
                          bool running = await service.isRunning();
                          print("Running Is : $running");
                          if (!running) {
                            service.startService();
                            running = await service.isRunning();
                            print("Running Is : $running");
                            if (running) {
                              Get.back();
                            }
                          }
                        }
                      },
                      child: Row(
                        children: const [Text("OK"), Icon(Icons.add)],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
