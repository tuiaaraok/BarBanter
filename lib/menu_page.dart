import 'dart:developer';

import 'package:favorite_bars/calendar_page.dart';
import 'package:favorite_bars/friend_page.dart';
import 'package:favorite_bars/list_of_my_places.dart';
import 'package:favorite_bars/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() {
    return _MenuPageState();
  }
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image(
                image: const AssetImage(
                  "assets/menu.png",
                ),
                width: 403.w,
                height: 302.h,
              ),
              SizedBox(
                height: 255.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const ListOfMyPlaces(),
                              ));
                        },
                        child:
                            CustomWidgets.infoBtn("Trips", 332.w, 62.h, 26.sp)),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const CalendarPage(),
                              ));
                        },
                        child: CustomWidgets.infoBtn(
                            "Analytics", 332.w, 62.h, 26.sp)),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const FriendPage(),
                              ));
                        },
                        child: CustomWidgets.infoBtn(
                            "Friends", 332.w, 62.h, 26.sp)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.paddingOf(context).bottom),
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: SizedBox(
                      height: 37.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    String? encodeQueryParameters(
                                        Map<String, String> params) {
                                      return params.entries
                                          .map((MapEntry<String, String> e) =>
                                              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                          .join('&');
                                    }

                                    // ···
                                    final Uri emailLaunchUri = Uri(
                                      scheme: 'mailto',
                                      path: 'bilalmama98@icloud.com',
                                      query: encodeQueryParameters(<String,
                                          String>{
                                        '': '',
                                      }),
                                    );
                                    try {
                                      if (await canLaunchUrl(emailLaunchUri)) {
                                        await launchUrl(emailLaunchUri);
                                      } else {
                                        throw Exception(
                                            "Could not launch $emailLaunchUri");
                                      }
                                    } catch (e) {
                                      log('Error launching email client: $e'); // Log the error
                                    }
                                  },
                                  child: Text(
                                    "Contact Us",
                                    style: TextStyle(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  height: double.infinity,
                                  child: Text(
                                    "|",
                                    style: TextStyle(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final Uri url = Uri.parse(
                                        'https://docs.google.com/document/d/1oWDKD0VviXzmvZUzXvUlKgu2wbMIZ7xrwC7JBcSOxpg/mobilebasic');
                                    if (!await launchUrl(url)) {
                                      throw Exception('Could not launch $url');
                                    }
                                  },
                                  child: Text(
                                    "Privacy Policy",
                                    style: TextStyle(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  height: double.infinity,
                                  child: Text(
                                    "|",
                                    style: TextStyle(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                InAppReview.instance.openStoreListing(
                                  appStoreId: '6739551419',
                                );
                                // 6739551419
                              },
                              child: Text(
                                "Rate Us",
                                style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
