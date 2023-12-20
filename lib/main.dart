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

const MethodChannel alarmChannel = MethodChannel('com.example.bokertov');

Future<void> alarmLaunchMethod(MethodCall call) async {
  switch (call.method) {
    case 'onAlarmTriggered':
      Get.toNamed("/alarm-ring");
      print("app was launch");
      break;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  alarmChannel.setMethodCallHandler((call) => alarmLaunchMethod(call));

  // Iintilzaing Hive
  await Hive.initFlutter();
  Hive.registerAdapter(AlarmBoxItemAdapter());
  await Hive.openBox<AlarmBoxItem>("alarmsBox");

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFFF5F5F5),
    statusBarIconBrightness: Brightness.dark,
  ));

  // Initializing Google service
  GoogleService().handleSignIn();

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
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.lightBlue,
          shape: CircleBorder(),
        ),
        switchTheme: const SwitchThemeData(
            overlayColor: MaterialStatePropertyAll(Colors.blue)),
        bottomAppBarTheme: const BottomAppBarTheme(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shape: CircularNotchedRectangle(),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        primaryColor: Colors.blue,
        buttonTheme: const ButtonThemeData(buttonColor: Colors.blue),
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Colors.white),
      ),
      routes: {
        "/": (context) => const HomeScreen(),
        "/alarm-ring": (context) => const AlarmRingScreen(),
      },
    );
  }
}
