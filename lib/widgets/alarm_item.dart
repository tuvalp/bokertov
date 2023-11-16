import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Service
import '../services/alarm_box.dart';
import '../services/alarm_box_item.dart';

// Widget
import './alarm_control.dart';
import './alarm_delete.dart';

class AlarmItem extends StatefulWidget {
  final AlarmBoxItem alarm;
  final int index;

  AlarmItem(this.alarm, this.index);

  @override
  State<AlarmItem> createState() => _AlarmItemState();
}

class _AlarmItemState extends State<AlarmItem> {
  AlarmBoxService alarmBoxService = AlarmBoxService();

  void moreButtonClick(context) {
    showModalBottomSheet(
        context: context, builder: (context) => AlarmDelete(widget.index));
  }

  void itemClick(context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      showDragHandle: false,
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),
        child: AlarmContorl(widget.alarm, widget.index, true),
      ),
    );
  }

  void onSwitchChange(isActive) {
    alarmBoxService.update(
        AlarmBoxItem(
            id: widget.alarm.id,
            time: widget.alarm.time,
            note: widget.alarm.note,
            isActive: !isActive),
        widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => itemClick(context),
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.only(bottom: 15, top: 15, right: 5, left: 25),
        decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(DateFormat('HH:mm').format(widget.alarm.time),
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                    )),
                widget.alarm.note != ""
                    ? Text(widget.alarm.note,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w100,
                          color: Colors.grey,
                        ))
                    : Container(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Switch(
                    value: widget.alarm.isActive,
                    onChanged: (isActive) {
                      isActive = !isActive;
                      onSwitchChange(isActive);
                    }),
                IconButton(
                    onPressed: () => moreButtonClick(context),
                    iconSize: 26,
                    icon: const Icon(Icons.more_vert)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
