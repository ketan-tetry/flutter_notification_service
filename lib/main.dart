import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'notification_util/notification_service_helper.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationServiceHelper.instance.initialize();
  NotificationServiceHelper.instance.showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<NavigatorState> _globalKey;

  @override
  void initState() {
    _globalKey = GlobalKey<NavigatorState>();
    NotificationServiceHelper.instance.setGlobalNavigationKey(_globalKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notification Demo',
      navigatorKey: _globalKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Notification Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    NotificationServiceHelper.instance.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            MaterialButton(
                child: const Text("Is Auto Start Enabled"),
                onPressed: () async {
                  bool isAutoStartEnabled = await NotificationServiceHelper
                      .instance
                      .isAutoStartEnabled();
                  Fluttertoast.showToast(
                      msg:
                          "Auto start is ${isAutoStartEnabled ? "Enabled" : "Disabled"}");
                }),
            MaterialButton(
                child: const Text("Is Battery optimization disabled"),
                onPressed: () async {
                  bool isBatteryOptimizationDisabled =
                      await NotificationServiceHelper.instance
                          .isBatteryOptimizationDisabled();
                  Fluttertoast.showToast(
                      msg:
                          "Battery optimization is ${!isBatteryOptimizationDisabled ? "Enabled" : "Disabled"}");
                }),
            MaterialButton(
                child:
                    const Text("Is Manufacturer Battery optimization disabled"),
                onPressed: () async {
                  bool isManBatteryOptimizationDisabled =
                      await NotificationServiceHelper.instance
                          .isManufacturerBatteryOptimizationDisabled();
                  Fluttertoast.showToast(
                      msg:
                          "Manufacturer Battery optimization is ${!isManBatteryOptimizationDisabled ? "Enabled" : "Disabled"}");
                }),
            MaterialButton(
                child: const Text("Are All Battery optimizations disabled"),
                onPressed: () async {
                  bool isAllBatteryOptimizationDisabled =
                      await NotificationServiceHelper.instance
                          .isAllBatteryOptimizationDisabled();
                  Fluttertoast.showToast(
                      msg:
                          "All Battery optimizations are disabled ${isAllBatteryOptimizationDisabled ? "True" : "False"}");
                }),
            MaterialButton(
                child: const Text("Enable Auto Start"),
                onPressed: () {
                  NotificationServiceHelper.instance
                      .showEnableAutoStartSettings();
                }),
            MaterialButton(
                child: const Text("Disable Battery Optimizations"),
                onPressed: () {
                  NotificationServiceHelper.instance
                      .showDisableBatteryOptimizationSettings();
                }),
            MaterialButton(
                child: const Text("Disable Manufacturer Battery Optimizations"),
                onPressed: () {
                  NotificationServiceHelper.instance
                      .showDisableManufacturerBatteryOptimizationSettings();
                }),
            MaterialButton(
                child: const Text("Disable all Optimizations"),
                onPressed: () {
                  NotificationServiceHelper.instance
                      .showDisableAllOptimizationsSettings();
                })
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
