import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'places_model.g.dart';

@HiveType(typeId: 1)
class PlacesModel {
  @HiveField(0)
  List<PlaceModel> placesList = [];
  PlacesModel({required this.placesList});
}

@HiveType(typeId: 2)
class PlaceModel {
  @HiveField(0)
  DateTime date;
  @HiveField(1)
  Uint8List imageBar;
  @HiveField(2)
  int stars;
  @HiveField(3)
  String name;
  @HiveField(4)
  String address;
  PlaceModel(
      {required this.date,
      required this.imageBar,
      required this.stars,
      required this.name,
      required this.address});
}
