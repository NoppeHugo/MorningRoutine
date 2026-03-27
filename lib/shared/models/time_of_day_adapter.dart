import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
 
class TimeOfDayAdapter extends TypeAdapter<TimeOfDay> {
  @override
  final int typeId = 100;
 
  @override
  TimeOfDay read(BinaryReader reader) {
    return TimeOfDay(hour: reader.readInt(), minute: reader.readInt());
  }
 
  @override
  void write(BinaryWriter writer, TimeOfDay obj) {
    writer.writeInt(obj.hour);
    writer.writeInt(obj.minute);
  }
}
