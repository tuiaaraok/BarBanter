// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'places_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlacesModelAdapter extends TypeAdapter<PlacesModel> {
  @override
  final int typeId = 1;

  @override
  PlacesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlacesModel(
      placesList: (fields[0] as List).cast<PlaceModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, PlacesModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.placesList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlacesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlaceModelAdapter extends TypeAdapter<PlaceModel> {
  @override
  final int typeId = 2;

  @override
  PlaceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaceModel(
      date: fields[0] as DateTime,
      imageBar: fields[1] as Uint8List,
      stars: fields[2] as int,
      name: fields[3] as String,
      address: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PlaceModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.imageBar)
      ..writeByte(2)
      ..write(obj.stars)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
