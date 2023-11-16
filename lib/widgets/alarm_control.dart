import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

// Service
import '../services/alarm_box.dart';
import '../services/alarm_box_item.dart';

class AlarmContorl extends StatefulWidget {
  final AlarmBoxItem? alarm;
  final int? index;
  final bool? updateMode;
  final Function? updateSwitch;

  const AlarmContorl(
      [this.alarm, this.index, this.updateMode, this.updateSwitch]);

  @override
  State<AlarmContorl> createState() => _AlarmCntorlState();
}

class _AlarmCntorlState extends State<AlarmContorl> {
  AlarmBoxService alarmBoxService = AlarmBoxService();

  TextEditingController noteController = TextEditingController();
  int id = DateTime.now().microsecondsSinceEpoch;
  DateTime time = DateTime.now().add(const Duration(minutes: 1));
  String note = "";
  bool isActive = true;

  @override
  void initState() {
    if (widget.updateMode == true) {
      id = widget.alarm!.id;
      time = widget.alarm!.time;
      note = widget.alarm!.note;
      isActive = widget.alarm!.isActive;

      if (widget.alarm!.note.isNotEmpty) {
        noteController = TextEditingController(text: widget.alarm!.note);
      }
    }
    super.initState();
  }

  void onCloseButton() {
    Navigator.of(context).pop();
  }

  void onCheakButton() {
    var courentAlarm =
        AlarmBoxItem(id: id, isActive: isActive, note: note, time: time);

    if (widget.updateMode == true) {
      alarmBoxService.update(courentAlarm, widget.index);
    } else {
      alarmBoxService.add(courentAlarm);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return Padding(
      padding: mediaQueryData.viewInsets,
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 500,
        color: Colors.white,
        child: Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 2,
              child: TimePickerSpinner(
                time: time,
                is24HourMode: true,
                isForce2Digits: true,
                itemHeight: 60,
                spacing: 35,
                onTimeChange: (newTime) => setState(() {
                  time = newTime.copyWith(second: 0);
                }),
                normalTextStyle:
                    const TextStyle(fontSize: 34, fontWeight: FontWeight.w300),
                highlightedTextStyle: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w400,
                  color: Colors.blue,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Active",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.grey,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.center,
                          child: Switch(
                              value: isActive,
                              onChanged: (value) {
                                setState(() {
                                  isActive = !isActive;
                                });
                              }),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Note",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.grey,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: TextField(
                            controller: noteController,
                            onChanged: (value) => setState(() {
                                  note = noteController.text;
                                }),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.blue),
                            decoration: const InputDecoration.collapsed(
                              hintText: "Note",
                              hintStyle: TextStyle(color: Colors.blue),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () => onCloseButton(),
                    icon: const Icon(
                      Icons.close,
                      size: 30,
                    )),
                IconButton(
                    onPressed: () => onCheakButton(),
                    icon: const Icon(
                      Icons.check,
                      size: 30,
                      color: Colors.blue,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
