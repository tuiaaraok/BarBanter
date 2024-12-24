import 'package:favorite_bars/add_friend_page.dart';
import 'package:favorite_bars/hive/friend_model.dart';
import 'package:favorite_bars/hive/hive_box.dart';
import 'package:favorite_bars/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  TextEditingController searchController = TextEditingController();
  String searchText = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchText = searchController.text.toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable:
              Hive.box<FriendModel>(HiveBoxes.friendModel).listenable(),
          builder: (context, Box<FriendModel> box, _) {
            final friend = box.values.where(
                (place) => place.name.toLowerCase().contains(searchText));
            return Padding(
              padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 20.w),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child:
                              SvgPicture.asset("assets/icons/menu_icon.svg")),
                    ),
                  ),
                  Text(
                    "Friends",
                    style:
                        TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  CustomWidgets.search(searchController),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const AddFriendPage(),
                          ),
                        );
                      },
                      child: CustomWidgets.infoBtn(
                          "+Add friend", 260.w, 44.h, 22.sp),
                    ),
                  ),
                  for (var val in friend) ...[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Container(
                        width: 350.w,
                        height: 54.h,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r)),
                            border:
                                Border.all(color: Colors.black, width: 2.w)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            children: [
                              Container(
                                width: 33.w,
                                alignment: Alignment.topCenter,
                                decoration: val.imageFriend == null
                                    ? BoxDecoration(
                                        color: const Color(0xFF00A0A6),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.black, width: 2.w))
                                    : BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image:
                                                MemoryImage(val.imageFriend!),
                                            fit: BoxFit.fill),
                                        border: Border.all(
                                            color: Colors.black, width: 2.w)),
                                child: Center(
                                  child: Text(
                                    val.name[0].toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 26.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    val.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.sp,
                                      height: 1,
                                    ),
                                  ),
                                  Text(
                                    val.phone,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.sp,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              SvgPicture.asset("assets/icons/friend_icon.svg"),
                            ],
                          ),
                        ),
                      ),
                    )
                  ]
                ],
              ),
            );
          }),
    );
  }
}
