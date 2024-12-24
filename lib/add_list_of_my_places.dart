import 'dart:developer';

import 'package:favorite_bars/hive/friend_model.dart';
import 'package:favorite_bars/hive/hive_box.dart';
import 'package:favorite_bars/hive/places_model.dart';
import 'package:favorite_bars/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddListOfMyPlaces extends StatefulWidget {
  const AddListOfMyPlaces({super.key});

  @override
  State<AddListOfMyPlaces> createState() => _AddListOfMyPlacesState();
}

class _AddListOfMyPlacesState extends State<AddListOfMyPlaces> {
  TextEditingController enterNameOfBar = TextEditingController();
  TextEditingController enterAddressOfBar = TextEditingController();
  Map<String, List<int>> currentState = {
    "Overall rating": [],
    "Interior": [],
    "Kitchen": [],
    "Drinks": [],
    "Service": [],
    "Music": [],
    "Atmosphere": [],
    "Price": [],
    "Territoriality": []
  };

  bool isOpenDropMenuFriend = false;
  Box<FriendModel> friendsBox = Hive.box<FriendModel>(HiveBoxes.friendModel);
  Box<PlacesModel> placesBox = Hive.box<PlacesModel>(HiveBoxes.placesModel);

  String currentFriend = "";
  Uint8List? _image;
  Future getLostData() async {
    XFile? picker = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picker == null) return;
    List<int> imageBytes = await picker.readAsBytes();
    _image = Uint8List.fromList(imageBytes);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  "List of my places",
                  style:
                      TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 30.h,
                ),
                // Измените функцию onToggle в вашем виджете на следующий код:
                CustomWidgets.textFieldForm("Enter name of bar", 350.w,
                    enterNameOfBar, Colors.black, Colors.white, Colors.black),
                CustomWidgets.textFieldForm(
                    "Enter address of bar",
                    350.w,
                    enterAddressOfBar,
                    Colors.black,
                    Colors.white,
                    Colors.black),
                SizedBox(
                  height: 8.h,
                ),

                CustomWidgets.textFieldViewCategory(
                    "Who were you with?",
                    350.w,
                    currentFriend,
                    isOpenDropMenuFriend,
                    () {
                      // Переключение состояния isOpenDropMenuFriend
                      setState(() {
                        isOpenDropMenuFriend = !isOpenDropMenuFriend;
                      });
                    },
                    [
                      "One",
                      ...friendsBox.values.map((toElement) {
                        return toElement.name;
                      })
                    ],
                    (t0) {
                      isOpenDropMenuFriend = !isOpenDropMenuFriend;
                      currentFriend = t0;
                      setState(() {});
                    }),
                SizedBox(
                  height: 30.h,
                ),
                for (var description in currentState.keys) ...[
                  CustomWidgets.ratingCategory(description, 350.w, currentState,
                      (index) {
                    if (currentState[description]?.length == index + 1) {
                      currentState.clear();
                    } else {
                      currentState[description] =
                          List<int>.generate(index + 1, (int i) => i);
                    }

                    setState(() {});
                  }),
                ],
                SizedBox(
                  height: 20.h,
                ),

                GestureDetector(
                  onTap: () async {
                    try {
                      await getLostData();
                      setState(() {});
                    } catch (e) {
                      log(e.toString());
                    }
                  },
                  child: Container(
                    width: 339.w,
                    height: 120.h,
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFD465),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.black, width: 2.h),
                        image: _image != null
                            ? DecorationImage(
                                image: MemoryImage(_image!), fit: BoxFit.fill)
                            : null,
                        boxShadow: [
                          BoxShadow(offset: Offset(0, 4.h), color: Colors.black)
                        ]),
                    child: Center(
                        child: Text(
                      "+Add a photo",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    )),
                  ),
                ),
                SizedBox(
                  height: 108.h,
                ),
                SizedBox(
                  width: 339.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 160.w,
                          height: 45.h,
                          decoration: BoxDecoration(
                              color: const Color(0xFFFF4949),
                              borderRadius: BorderRadius.circular(10.r),
                              border:
                                  Border.all(color: Colors.black, width: 2.h),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 4.h), color: Colors.black)
                              ]),
                          child: Center(
                              child: Text(
                            "Cancel",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_image != null &&
                              enterNameOfBar.text.isNotEmpty &&
                              enterAddressOfBar.text.isNotEmpty) {
                            double rescount = 0;
                            for (var action in currentState.values) {
                              rescount += action.length;
                            }
                            rescount /= 9;
                            log(rescount.toString());
                            log(rescount.round().toString());
                            DateFormat('yy/MM').format(DateTime.now());
                            placesBox.put(
                                DateFormat('yy/MM').format(DateTime.now()),
                                PlacesModel(placesList: [
                                  PlaceModel(
                                      date: DateTime.now(),
                                      imageBar: _image!,
                                      stars: rescount.round(),
                                      name: enterNameOfBar.text,
                                      address: enterAddressOfBar.text),
                                  ...placesBox
                                          .get(DateFormat('yy/MM')
                                              .format(DateTime.now()))
                                          ?.placesList ??
                                      []
                                ]));
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: 160.w,
                          height: 45.h,
                          decoration: BoxDecoration(
                              color: const Color(0xFF00A0A6),
                              borderRadius: BorderRadius.circular(10.r),
                              border:
                                  Border.all(color: Colors.black, width: 2.h),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 4.h), color: Colors.black)
                              ]),
                          child: Center(
                              child: Text(
                            "Save",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  height: MediaQuery.paddingOf(context).bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
