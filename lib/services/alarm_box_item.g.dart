// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_box_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlarmBoxItemAdapter extends TypeAdapter<AlarmBoxItem> {
  @override
  final int typeId = 1;

  @override
  AlarmBoxItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlarmBoxItem(
      id: fields[0] as int,
      time: fields[1] as DateTime,
      note: fields[2] as String,
      isActive: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AlarmBoxItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.note)
      ..writeByte(3)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmBoxItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
