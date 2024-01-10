import 'package:bokertov/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';

// Screens
import '../screens/home_page.dart';
import '../screens/alarm_ring.dart';

// Service
import './services/alarm_box_item.dart';
import './services/google_service.dart';
import './services/account_box_item.dart';

const MethodChannel alarmChannel = MethodChannel('com.example.bokertov');

Future<void> alarmLaunchMethod(MethodCall call) async {
  switch (call.method) {
    case 'onAlarmTriggered':
      Get.toNamed("/alarm-ring");
      break;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  alarmChannel.setMethodCallHandler((call) => alarmLaunchMethod(call));

  // Iintilzaing Hive
  await Hive.initFlutter();
  Hive.registerAdapter(AlarmBoxItemAdapter());
  Hive.registerAdapter(GoogleSignInAccountAdapter());
  await Hive.openBox<AlarmBoxItem>("alarmsBox");
  await Hive.openBox<GoogleSignInAccountitem>("account");

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFFF5F5F5),
    statusBarIconBrightness: Brightness.dark,
  ));

  // Initializing Google service
  await GoogleService().handleSignIn();

  runApp(const AlarmClock());
}

class AlarmClock extends StatelessWidget {
  const AlarmClock({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Alarm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: false),
      routes: {
        "/": (context) => const HomeScreen(),
        "/alarm-ring": (context) => const AlarmRingScreen(),
        "/settings": (context) => SettingScreen(),
      },
    );
  }
}
