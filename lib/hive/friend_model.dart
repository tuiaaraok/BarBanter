import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'friend_model.g.dart';

@HiveType(typeId: 3)
class FriendModel {
  @HiveField(0)
  Uint8List? imageFriend;
  @HiveField(1)
  String name;
  @HiveField(2)
  String phone;
  FriendModel({this.imageFriend, required this.name, required this.phone});
}
