import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Widget
import './alarm_item.dart';

// Services
import '../services/alarm_box_item.dart';

class AlarmView extends StatefulWidget {
  const AlarmView({super.key});

  @override
  State<AlarmView> createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {
  final _myAlarms = Hive.box<AlarmBoxItem>("alarmsBox");

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ValueListenableBuilder(
          valueListenable: _myAlarms.listenable(),
          builder: (context, Box box, _) {
            if (box.values.isNotEmpty) {
              return ListView.builder(
                  itemCount: box.values.length,
                  itemBuilder: (context, index) {
                    var alarm = box.getAt(index);
                    return AlarmItem(alarm, index);
                  });
            } else {
              return const Center(
                child: Text(
                  "There are no alarm clocks set",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              );
            }
          }),
    );
  }
}
