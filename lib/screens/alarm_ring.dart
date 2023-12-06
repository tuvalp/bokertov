import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_ios_ringtone_player/flutter_ios_ringtone_player.dart';

import '../services/alarm_box.dart';

const MethodChannel channel = MethodChannel('com.example.bokertov');

class AlarmRingScreen extends StatefulWidget {
  const AlarmRingScreen({super.key});

  @override
  State<AlarmRingScreen> createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends State<AlarmRingScreen> {
  late String message = "";

  @override
  void initState() {
    ringtonePlay();
    channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onAlarmTriggered') {
        message = call.arguments.toString();
        print('Received alarm message: $message');
      }
    });
    super.initState();
  }

  void ringtonePlay() {
    FlutterRingtonePlayer.play(
      android: AndroidSounds.alarm,
      looping: true,
      volume: 1,
      asAlarm: true,
    );

    FlutterIosRingtonePlayer.play(soundId: 1005);
  }

  void onStopButtonClick() {
    AlarmBoxService().setAlarms();
    FlutterRingtonePlayer.stop();
    FlutterIosRingtonePlayer.stop(soundId: 1005);
    Get.toNamed("/");
  }

  void onSnozButtonClick() {
    AlarmBoxService().setSnooz();
    FlutterRingtonePlayer.stop();
    Get.toNamed("/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('yMMMMEEEEd').format(DateTime.now()),
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                        fontWeight: FontWeight.w100),
                  ),
                  Text(
                    DateFormat('HH:mm').format(DateTime.now()),
                    style: const TextStyle(
                        fontSize: 96, fontWeight: FontWeight.w200),
                  ),
                  message != ""
                      ? Text(
                          message,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                              fontWeight: FontWeight.w100),
                        )
                      : Container(),
                ],
              ),
            ),
            Flexible(
                child: Center(
              child: TextButton(
                onPressed: () => onSnozButtonClick(),
                child: Container(
                  width: 140,
                  height: 140,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(color: Colors.blue, width: 2),
                    color: Colors.transparent,
                  ),
                  child: const Text(
                    "Snooz",
                    style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue),
                  ),
                ),
              ),
            )),
            Flexible(
              child: Container(
                padding: const EdgeInsets.only(top: 170),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    padding: const EdgeInsets.all(10),
                    textStyle: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.w200),
                  ),
                  child: const Text(
                    "Stop",
                  ),
                  onPressed: () => onStopButtonClick(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
