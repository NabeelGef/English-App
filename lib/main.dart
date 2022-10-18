import 'dart:ui';

import 'package:english_app/controller/Helper/Counter.dart';
import 'package:english_app/controller/Helper/Storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:system_alert_window/system_alert_window.dart';

import 'package:english_app/Views/AddWords.dart';
import 'package:english_app/controller/Helper/Constant.dart';
import 'package:english_app/controller/englishWordController.dart';
import 'package:english_app/models/englishWords.dart';

List<EnglishWord> english = [];
Helper helper = Helper();
Storage storage = Storage();

// void backgroundFetchHeadlessTask(HeadlessTask task) async {
//   String taskId = task.taskId;
//   bool isTimeout = task.timeout;
//   if (isTimeout) {
//     // This task has exceeded its allowed running-time.
//     // You must stop what you're doing and immediately .finish(taskId)
//     print("[BackgroundFetch] Headless task timed-out: $taskId");
//     BackgroundFetch.finish(taskId);
//     return;
//   }
//   print('[BackgroundFetch] Headless event received.');
//   // Do your work here...
//   BackgroundFetch.finish(taskId);
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(EnglishWordControllerAdapter());
  Hive.registerAdapter(EnglishWordAdapter());
  //Storage.PutShowingSystemAlert(0);
  //BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  await Hive.openBox('Data');
  Counter counter = Counter();
  Counter.initializeService();
  //helper.ClearData();
  // english = box.get('words') as List<EnglishWord>;

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: "English APP",
    home: const Home(),
    getPages: [
      GetPage(
        name: "/addwords",
        page: () => const AddWords(),
      ),
      GetPage(
        name: "/home",
        page: () => const Home(),
      ),
    ],
  ));
}

//  else {
//   setState(() {
//     _isShowingWindow = false;
//   });
//   SystemAlertWindow.closeSystemWindow(prefMode: prefMode);
// }

//@pragma('vm:entry-point')

bool callBackFunction(String tag) {
  // _init();
  if (tag == "simple_button") {
    print("Closed!!!");
    SystemAlertWindow.closeSystemWindow(prefMode: SystemWindowPrefMode.OVERLAY);
  }
  // SendPort? port = IsolateManager.lookupPortByName();
  // port!.send([tag]);

  return true;
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    SystemAlertWindow.registerOnClickListener(callBackFunction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Learning English"),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Get.toNamed("/addwords");
              },
            )),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            color: Colors.amber,
            width: double.infinity,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "English : ",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ))),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("العربية : ",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 25,
                            )))),
              ],
            ),
          ),
          GetBuilder(
              init: EnglishWordController(),
              builder: (controller) {
                english = helper.getBox();
                return english.isEmpty
                    ? const Center(
                        child: Text(
                          "There aren't any Data",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 25,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: english.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                leading: Text(
                                  english[index].English,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                trailing: Text(english[index].Arabic,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    )),
                              ),
                              const Divider(
                                indent: 3,
                                thickness: 4,
                                color: Colors.amber,
                              )
                            ],
                          );
                        },
                      );
              })
        ])));
  }
}
