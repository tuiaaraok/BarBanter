import 'dart:developer';

import 'package:favorite_bars/hive/friend_model.dart';
import 'package:favorite_bars/hive/hive_box.dart';
import 'package:favorite_bars/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({super.key});

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  TextEditingController enterFriendName = TextEditingController();
  TextEditingController enterPhoneNumber = TextEditingController();
  Uint8List? _image;
  Box<FriendModel> friendsBox = Hive.box<FriendModel>(HiveBoxes.friendModel);
  Future getLostData() async {
    XFile? picker = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picker == null) return;
    List<int> imageBytes = await picker.readAsBytes();
    _image = Uint8List.fromList(imageBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
        child: SafeArea(
          child: Column(
            children: [
              Text(
                "Friends",
                style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 30.h,
              ),
              CustomWidgets.textFieldForm("Enter name of bar", 350.w,
                  enterFriendName, Colors.black, Colors.white, Colors.black),
              SizedBox(
                height: 10.h,
              ),
              CustomWidgets.textFieldForm("Enter phone number", 350.w,
                  enterPhoneNumber, Colors.black, Colors.white, Colors.black),
              SizedBox(
                height: 30.h,
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
              const Spacer(),
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
                            border: Border.all(color: Colors.black, width: 2.h),
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
                        if (enterFriendName.text.isNotEmpty &&
                            enterPhoneNumber.text.isNotEmpty) {
                          friendsBox.add(FriendModel(
                              imageFriend: _image,
                              name: enterFriendName.text,
                              phone: enterPhoneNumber.text));
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        width: 160.w,
                        height: 45.h,
                        decoration: BoxDecoration(
                            color: const Color(0xFF00A0A6),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: Colors.black, width: 2.h),
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
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
