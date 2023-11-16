import 'package:hive/hive.dart';

part 'alarm_box_item.g.dart';

@HiveType(typeId: 1)
class AlarmBoxItem {
  AlarmBoxItem({
    required this.id,
    required this.time,
    required this.note,
    required this.isActive,
  });
  @HiveField(0)
  int id;

  @HiveField(1)
  DateTime time;

  @HiveField(2)
  String note;

  @HiveField(3)
  bool isActive;
}
