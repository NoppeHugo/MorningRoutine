// GENERATED CODE - DO NOT MODIFY BY HAND
 
part of 'block_model.dart';
 
// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************
 
class BlockModelAdapter extends TypeAdapter<BlockModel> {
  @override
  final int typeId = 0;
 
  @override
  BlockModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BlockModel(
      id: fields[0] as String,
      templateId: fields[1] as String,
      name: fields[2] as String,
      emoji: fields[3] as String,
      durationMinutes: fields[4] as int,
      order: fields[5] as int,
    );
  }
 
  @override
  void write(BinaryWriter writer, BlockModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.templateId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.emoji)
      ..writeByte(4)
      ..write(obj.durationMinutes)
      ..writeByte(5)
      ..write(obj.order);
  }
 
  @override
  int get hashCode => typeId.hashCode;
 
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
