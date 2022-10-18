// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'englishWords.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EnglishWordAdapter extends TypeAdapter<EnglishWord> {
  @override
  final int typeId = 0;

  @override
  EnglishWord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EnglishWord(
      English: fields[0] as String,
      Arabic: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EnglishWord obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.English)
      ..writeByte(1)
      ..write(obj.Arabic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnglishWordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
