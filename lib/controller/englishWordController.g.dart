// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'englishWordController.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EnglishWordControllerAdapter extends TypeAdapter<EnglishWordController> {
  @override
  final int typeId = 1;

  @override
  EnglishWordController read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EnglishWordController()
      ..englishwords = (fields[0] as List).cast<EnglishWord>();
  }

  @override
  void write(BinaryWriter writer, EnglishWordController obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.englishwords);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnglishWordControllerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
