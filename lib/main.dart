import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:get/get.dart';

// Screens
import '../screens/home_page.dart';
import '../screens/alarm_ring.dart';

// Service
import './services/alarm_box_item.dart';

const MethodChannel alarmChannel = MethodChannel('com.example.bokertov');

Future<void> alarmLaunchMethod(MethodCall call) async {
  switch (call.method) {
    case 'onAlarmTriggered':
      Get.toNamed("/alarm-ring");
      break;
  }
}

Future<void> requestBackgroundFetchPermission() async {
  var status = await Permission.backgroundFetch.status;

  if (status.isUndetermined) {
    // Request permission
    await Permission.backgroundFetch.request();
  }

  // Check if permission is granted
  if (await Permission.backgroundFetch.isGranted) {
    print('Background fetch permission granted');
  } else {
    print('Background fetch permission denied');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  alarmChannel.setMethodCallHandler((call) => alarmLaunchMethod(call));

  // Iintilzaing Hive
  await Hive.initFlutter();
  Hive.registerAdapter(AlarmBoxItemAdapter());
  await Hive.openBox<AlarmBoxItem>("alarmsBox");
  await requestBackgroundFetchPermission();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFFF5F5F5),
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(const AlarmClock());
}

class AlarmClock extends StatelessWidget {
  const AlarmClock({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Alarm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        primaryColor: Colors.blue,
      ),
      routes: {
        "/": (context) => const HomeScreen(),
        "/alarm-ring": (context) => const AlarmRingScreen(),
      },
    );
  }
}
