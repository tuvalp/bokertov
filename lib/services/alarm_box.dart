import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import './alarm_box_item.dart';

const MethodChannel alarmChannel = MethodChannel('com.example.bokertov');

class AlarmBoxService {
  final alarmBox = Hive.box<AlarmBoxItem>("alarmsBox");

  Future<void> scheduleAlarm(int delay, String message) async {
    try {
      await alarmChannel
          .invokeMethod('scheduleAlarm', {'delay': delay, 'message': message});
    } on PlatformException catch (e) {
      print("Error: ${e.message}");
    }
  }

  Future<void> cancelAllAlarms() async {
    try {
      await alarmChannel.invokeMethod('cancelAllAlarms');
    } on PlatformException catch (e) {
      print("Error: ${e.message}");
    }
  }

  static int getMillisecondsToAlarm(DateTime now, DateTime alarmTime) {
    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    int milliseconds = alarmTime.difference(now).inMilliseconds;
    return milliseconds;
  }

  void setAlarms() async {
    var timeList = [];

    if (alarmBox.isNotEmpty) {
      cancelAllAlarms();

      for (var index = 0; index < alarmBox.length; index++) {
        var alarm = alarmBox.getAt(index);
        if (alarm != null && alarm.isActive == true) {
          var milliseconds = getMillisecondsToAlarm(DateTime.now(), alarm.time);
          timeList
              .add({"time": milliseconds, "id": alarm.id, "note": alarm.note});
        }
      }

      timeList.sort((a, b) => a['time'].compareTo(b['time']));

      if (timeList.isNotEmpty) {
        try {
          scheduleAlarm(timeList[0]["time"], timeList[0]["note"]);
        } catch (e) {
          print("Error scheduling alarm: $e");
        }
      }
    }
  }

  void setSnooz() async {
    scheduleAlarm(180000, "Wake up!");
  }

  void add(AlarmBoxItem alarm) {
    alarmBox.add(alarm);
    setAlarms();
  }

  void update(AlarmBoxItem alarm, index) {
    alarmBox.putAt(index, alarm);
    setAlarms();
  }

  void delete(index) {
    alarmBox.deleteAt(index);
    setAlarms();
  }
}
