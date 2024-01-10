// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_box_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoogleSignInAccountAdapter extends TypeAdapter<GoogleSignInAccountitem> {
  @override
  final int typeId = 2;

  @override
  GoogleSignInAccountitem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoogleSignInAccountitem(
      displayName: fields[0] as String,
      email: fields[1] as String,
      id: fields[2] as String,
      photoUrl: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GoogleSignInAccountitem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.displayName)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.photoUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoogleSignInAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
