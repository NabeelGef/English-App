import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:system_alert_window/system_alert_window.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

import '../../models/englishWords.dart';
import '../englishWordController.dart';
import 'Constant.dart';

class Counter {
  final _box;
  SystemWindowPrefMode prefMode = SystemWindowPrefMode.OVERLAY;

  Counter() : _box = Hive.box('Data') {
    _initPlatformState();
    _requestPermissions();
  }

  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
          // this will be executed when app is in foreground or background in separated isolate
          onStart: Counter.onStart,

          // auto start service
          autoStart: true,
          isForegroundMode: true),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will be executed when app is in foreground in separated isolate
        onForeground: Counter.onStart,

        // you have to enable background fetch capability on xcode project
        //onBackground: onIosBackground,
      ),
    );

    service.startService();
  }

  Future<void> _initPlatformState() async {
    await SystemAlertWindow.enableLogs(true);
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = (await SystemAlertWindow.platformVersion)!;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;

    //setState(() {});
  }

  Future<void> _requestPermissions() async {
    await SystemAlertWindow.requestPermissions(prefMode: prefMode);
  }

  void _showOverlayWindow(String englishWord, String arabicWord) {
    SystemWindowHeader header = SystemWindowHeader(
        title: SystemWindowText(
            text: "تذكرة مفيدة",
            fontSize: 20,
            textColor: Colors.black,
            fontWeight: FontWeight.BOLD),
        padding: SystemWindowPadding(left: 170));
    SystemWindowBody body = SystemWindowBody(
      decoration: SystemWindowDecoration(
          borderRadius: 100, startColor: Colors.grey, endColor: Colors.grey),
      rows: [
        EachRow(columns: [
          EachColumn(
            text: SystemWindowText(
                text: "$englishWord",
                fontSize: 15,
                fontWeight: FontWeight.BOLD),
          ),
          EachColumn(
              text: SystemWindowText(
                  text: "$arabicWord",
                  fontSize: 15,
                  fontWeight: FontWeight.BOLD),
              padding: SystemWindowPadding(left: 250))
        ], gravity: ContentGravity.CENTER),
      ],
      padding: SystemWindowPadding(left: 16, right: 16, bottom: 12, top: 12),
    );
    SystemWindowFooter footer = SystemWindowFooter(
        buttons: [
          SystemWindowButton(
            text: SystemWindowText(
                text: "Cancel",
                fontWeight: FontWeight.BOLD,
                fontSize: 12,
                textColor: Color.fromARGB(255, 167, 252, 10)),
            tag: "simple_button",
            padding:
                SystemWindowPadding(left: 100, right: 100, bottom: 10, top: 10),
            height: SystemWindowButton.WRAP_CONTENT,
            decoration: SystemWindowDecoration(
              borderRadius: 50,
              borderWidth: 10,
              startColor: Colors.red,
              endColor: Colors.green,
            ),
          ),
        ],

        //padding: SystemWindowPadding(left: 16, right: 16, bottom: 12),
        //decoration: SystemWindowDecoration(startColor: Colors.yellow),
        buttonsPosition: ButtonPosition.CENTER);
    SystemAlertWindow.showSystemWindow(
        height: 100,
        header: header,
        body: body,
        footer: footer,
        margin: SystemWindowMargin(left: 8, right: 8, top: 200, bottom: 0),
        gravity: SystemWindowGravity.TOP,
        notificationTitle: "Incoming Call",
        notificationBody: "+1 646 980 4741",
        prefMode: prefMode);
  }

  List<EnglishWord> getBox() {
    List? fromHive = _box.get('words');
    List<EnglishWord> english = [];
    if (fromHive != null) {
      for (EnglishWord i in fromHive) {
        print("Data is : ===> ${i.Arabic} ===> ${i.English}");
        english.add(i);
      }
    }
    return english;
  }

  static void onStart(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();
    await Hive.initFlutter();
    Hive.registerAdapter(EnglishWordControllerAdapter());
    Hive.registerAdapter(EnglishWordAdapter());
    await Hive.openBox('Data');
    if (service is AndroidServiceInstance) {
      service.on("close").listen((event) {
        service.stopSelf();
      });
    }
    Timer.periodic(const Duration(seconds: 120), (timer) async {
      //Storage.PutShowingSystemAlert(0);
      //BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
      final englishWord = Get.put(EnglishWordController());
      print("English Length : ${Counter().getBox().length}");
      if (Counter().getBox().length > 0) {
        int x = Random().nextInt(((Counter().getBox().length)));
        print("Random is : $x");
        Counter()._showOverlayWindow(
            Counter().getBox()[x].English, Counter().getBox()[x].Arabic);
      }
    });
    //
    // //Storage.PutShowingSystemAlert(0);
    // //BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
    // await Hive.initFlutter();
    // Hive.registerAdapter(EnglishWordControllerAdapter());
    // Hive.registerAdapter(EnglishWordAdapter());
    // await Hive.openBox('Data');
  }
}
