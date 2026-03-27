// GENERATED CODE - DO NOT MODIFY BY HAND
 
part of 'routine_model.dart';
 
// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************
 
class RoutineModelAdapter extends TypeAdapter<RoutineModel> {
  @override
  final int typeId = 1;
 
  @override
  RoutineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoutineModel(
      id: fields[0] as String,
      name: fields[1] as String,
      wakeTimeHour: fields[2] as int,
      wakeTimeMinute: fields[3] as int,
      blocks: (fields[4] as List).cast<BlockModel>(),
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
    );
  }
 
  @override
  void write(BinaryWriter writer, RoutineModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.wakeTimeHour)
      ..writeByte(3)
      ..write(obj.wakeTimeMinute)
      ..writeByte(4)
      ..write(obj.blocks)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }
 
  @override
  int get hashCode => typeId.hashCode;
 
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutineModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
