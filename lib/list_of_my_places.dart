import 'package:favorite_bars/add_list_of_my_places.dart';
import 'package:favorite_bars/hive/hive_box.dart';
import 'package:favorite_bars/hive/places_model.dart';
import 'package:favorite_bars/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ListOfMyPlaces extends StatefulWidget {
  const ListOfMyPlaces({super.key});

  @override
  State<ListOfMyPlaces> createState() => _ListOfMyPlacesState();
}

class _ListOfMyPlacesState extends State<ListOfMyPlaces> {
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
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: ValueListenableBuilder(
            valueListenable:
                Hive.box<PlacesModel>(HiveBoxes.placesModel).listenable(),
            builder: (context, Box<PlacesModel> box, _) {
              final places = box.values
                  .expand((toElement) => toElement.placesList)
                  .where(
                      (place) => place.name.toLowerCase().contains(searchText));
              return SingleChildScrollView(
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
                      "List of my places",
                      style: TextStyle(
                          fontSize: 28.sp, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    CustomWidgets.search(searchController),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const AddListOfMyPlaces(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: CustomWidgets.infoBtn(
                            "+Add places", 260.w, 44.h, 22.sp),
                      ),
                    ),
                    for (PlaceModel value in places) ...[
                      Padding(
                        padding: EdgeInsets.only(bottom: 17.h),
                        child: Container(
                          width: 319.w,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.r)),
                              border:
                                  Border.all(color: Colors.black, width: 2.w)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.h, horizontal: 7.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 5.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 220.w,
                                        child: Text(
                                          value.name,
                                          style: TextStyle(
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 220.w,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 8.h, bottom: 20.h),
                                          child: Text(
                                            value.address,
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                      Row(
                                          children:
                                              [0, 1, 2, 3, 4].map((index) {
                                        return Container(
                                          child: index >= value.stars
                                              ? SvgPicture.asset(
                                                  fit: BoxFit.contain,
                                                  "assets/icons/add_star.svg",
                                                  width: 24.w,
                                                  height: 24.h,
                                                )
                                              : SvgPicture.asset(
                                                  fit: BoxFit.contain,
                                                  "assets/icons/places_star.svg",
                                                  width: 24.w,
                                                  height: 24.h,
                                                ),
                                        );
                                      }).toList()),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 74.w,
                                  height: 93.h,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: MemoryImage(value.imageBar),
                                          fit: BoxFit.fill),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.r)),
                                      border: Border.all(
                                          color: Colors.black, width: 2.w)),
                                )
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
      ),
    );
  }
}
