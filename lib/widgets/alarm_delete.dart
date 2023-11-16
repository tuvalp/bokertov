import 'package:flutter/material.dart';

// Service
import '../services/alarm_box.dart';

class AlarmDelete extends StatelessWidget {
  final int index;
  final AlarmBoxService alarmBoxService = AlarmBoxService();
  AlarmDelete(this.index);

  void onDeleteClick(context) {
    alarmBoxService.delete(index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Center(
        child: IconButton(
          iconSize: 65,
          alignment: Alignment.center,
          onPressed: () => onDeleteClick(context),
          icon: Icon(
            Icons.delete,
            color: Colors.red.shade800,
          ),
        ),
      ),
    );
  }
}
