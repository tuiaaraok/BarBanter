import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:favorite_bars/firebase_options.dart';

import 'package:favorite_bars/hive/friend_model.dart';
import 'package:favorite_bars/hive/hive_box.dart';
import 'package:favorite_bars/hive/places_model.dart';
import 'package:favorite_bars/menu_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter(); // Инициализация Hive
  await Hive.openBox("Settings");
  // WidgetsFlutterBinding.ensureInitialized();
  // await Hive.initFlutter();
  Hive.registerAdapter(PlacesModelAdapter());
  Hive.registerAdapter(PlaceModelAdapter());
  Hive.registerAdapter(FriendModelAdapter());
  await Hive.openBox<PlacesModel>(HiveBoxes.placesModel);
  await Hive.openBox<FriendModel>(HiveBoxes.friendModel);

  // SystemChrome.setSystemUIOverlayStyle(
  //     SystemUiOverlayStyle(statusBarColor: Colors.black));
  await _initializeRemoteConfig().then((onValue) {
    runApp(MyApp(
      link: onValue,
    ));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.link});
  final String link;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(402, 874),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            // onGenerateRoute: NavigationApp.generateRoute,

            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.transparent,
                  systemOverlayStyle: SystemUiOverlayStyle.dark),
            ),
            home: Hive.box("privacyLink").isEmpty
                ? WebViewScreen(
                    link: link,
                  )
                : Hive.box("privacyLink")
                        .get('link')
                        .contains("showAgreebutton")
                    ? const MenuPage()
                    : WebViewScreen(
                        link: link,
                      )));
  }
}

Future<String> _initializeRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  var box = await Hive.openBox('privacyLink');
  String link = '';

  if (box.isEmpty) {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 1),
    ));

    // Defaults setup

    try {
      await remoteConfig.fetchAndActivate();

      link = remoteConfig.getString("link");
    } catch (e) {
      log("Failed to fetch remote config: $e");
    }
  } else {
    if (box.get('link').contains("showAgreebutton")) {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 1),
      ));

      try {
        await remoteConfig.fetchAndActivate();

        link = remoteConfig.getString("link");
      } catch (e) {
        log("Failed to fetch remote config: $e");
      }
      if (!link.contains("showAgreebutton")) {
        box.put('link', link);
      }
    } else {
      link = box.get('link');
    }
  }

  return link == ""
      ? "https://telegra.ph/AntiqueAtlas-Keep-Collection-Privacy-Policy-11-08?showAgreebutton"
      : link;
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key, required this.link});
  final String link;

  @override
  State<WebViewScreen> createState() {
    return _WebViewScreenState();
  }
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool loadAgree = false;
  WebViewController controller = WebViewController();
  final remoteConfig = FirebaseRemoteConfig.instance;

  @override
  void initState() {
    super.initState();
    if (Hive.box("privacyLink").isEmpty) {
      Hive.box("privacyLink").put('link', widget.link);
    }

    _initializeWebView(widget.link); // Initialize WebViewController
  }

  void _initializeWebView(String url) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              loadAgree = true;
              setState(() {});
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
    setState(() {}); // Optional, if you want to trigger a rebuild elsewhere
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: Stack(children: [
          WebViewWidget(controller: controller),
          if (loadAgree)
            GestureDetector(
                onTap: () async {
                  await Hive.openBox('privacyLink').then((box) {
                    box.put('link', widget.link);
                    Navigator.push(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const MenuPage(),
                      ),
                    );
                  });
                },
                child: widget.link.contains("showAgreebutton")
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Container(
                            width: 200,
                            height: 60,
                            color: Colors.amber,
                            child: const Center(child: Text("AGREE")),
                          ),
                        ))
                    : null),
        ]),
      ),
    );
  }
}

class CustomWidgets {
  static Widget dropMenuBtn(
      String description,
      String current,
      List<String> list,
      bool isOpenMenuCurrency,
      void Function(bool) openMenuChanger,
      void Function(String) changerCurrent) {
    return Column(
      children: [
        SizedBox(
          width: 160.w,
          child: Text(
            description,
            style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.w400),
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                onMenuStateChange: (isOpen) {
                  openMenuChanger(isOpen);
                },
                alignment: Alignment.center,
                customButton: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.w),
                        child: Wrap(
                            spacing: 10,
                            runAlignment: WrapAlignment.center,
                            alignment: WrapAlignment.start,
                            children: [
                              Text(
                                current,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp),
                              )
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: 43.h,
                      child: Icon(
                        isOpenMenuCurrency
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.black,
                        size: 30.w,
                      ),
                    ),
                  ],
                ),
                items: list
                    .expand((item) => [
                          DropdownMenuItem<String>(
                              value: item,
                              child: Container(
                                width: 172.w,
                                height: 50.h,
                                color: current == item
                                    ? const Color(0xFFEFF6FF)
                                    : Colors.white,
                                child: Center(
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      color: current == item
                                          ? Colors.black
                                          : const Color(0xFF06110A)
                                              .withValues(alpha: 0.5),
                                    ),
                                  ),
                                ),
                              )),
                        ])
                    .toList(),
                onChanged: (value) {
                  changerCurrent(value.toString());
                },
                dropdownStyleData: DropdownStyleData(
                  width: 160.w,
                  maxHeight: 300.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                  offset: Offset(-10.w, -10.h),
                ),
                menuItemStyleData: MenuItemStyleData(
                    customHeights: List.filled(list.length, 50.h),
                    padding:
                        EdgeInsets.only(top: 5.h, left: 10.w, right: 10.w)),
              ),
            )),
      ],
    );
  }

  static Widget infoBtn(
      String description, double width, double height, double textSize) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: const Color(0xFFFFD465),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.black, width: 2.h),
          boxShadow: [BoxShadow(offset: Offset(0, 4.h), color: Colors.black)]),
      child: Center(
          child: Text(
        description,
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
              fontSize: textSize,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
      )),
    );
  }

  static Widget textFieldForm(
      String description,
      double widthContainer,
      TextEditingController myController,
      Color title,
      Color container,
      Color stroke,
      {FocusNode? myNode,
      TextInputType? keyboard}) {
    return Column(
      children: [
        SizedBox(
          width: widthContainer,
          child: Text(
            description,
            style: TextStyle(
                fontSize: 18.sp, color: title, fontWeight: FontWeight.w400),
          ),
        ),
        Container(
          height: 40.h,
          width: widthContainer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.r)),
            color: container,
            border: Border.all(color: stroke, width: 2.w),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Center(
              child: TextField(
                focusNode: myNode,
                controller: myController,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                keyboardType: keyboard ?? TextInputType.text,
                cursorColor: title,
                style: TextStyle(
                    color: title, fontWeight: FontWeight.w500, fontSize: 16.sp),
                onChanged: (text) {
                  // Additional functionality can be added here
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget search(TextEditingController controller) {
    return Container(
      height: 56.h,
      width: 354.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
        boxShadow: [BoxShadow(offset: Offset(0, 2.h), color: Colors.black)],
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2.w),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Search',
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 21.sp)),
                keyboardType: TextInputType.text,
                cursorColor: Colors.black,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 21.sp),
                onChanged: (text) {
                  // Additional functionality can be added here
                },
              ),
            ),
            SvgPicture.asset("assets/icons/search.svg")
          ],
        ),
      ),
    );
  }

  static Widget ratingCategory(String description, double widthContainer,
      Map<String, List<int>> currentState, void Function(int) onTapRating) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: SizedBox(
        width: widthContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),
            ),
            SizedBox(
              height: 8.h,
            ),
            Row(
                children: [0, 1, 2, 3, 4].map((index) {
              return GestureDetector(
                onTap: () {
                  onTapRating(index);
                },
                child: currentState[description]?.contains(index) ?? false
                    ? SvgPicture.asset(
                        fit: BoxFit.contain,
                        "assets/icons/places_star.svg",
                        width: 24.w,
                        height: 24.h,
                      )
                    : SvgPicture.asset(
                        fit: BoxFit.contain,
                        "assets/icons/add_star.svg",
                        width: 24.w,
                        height: 24.h,
                      ),
              );
            }).toList()),
          ],
        ),
      ),
    );
  }

  static Widget textFieldViewCategory(
      String description,
      double widthContainer,
      String currentState,
      bool isOpenMenuCategory,
      VoidCallback onToggle,
      List<String> categoryMenu,
      void Function(String) onTapMenuElem) {
    return Column(
      children: [
        SizedBox(
          width: widthContainer,
          child: Text(
            description,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
        ),
        GestureDetector(
          onTap: () {
            onToggle();
          },
          child: Container(
            height: isOpenMenuCategory
                ? categoryMenu.isEmpty
                    ? 40.h
                    : null
                : 40.h,
            width: widthContainer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2.w),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: isOpenMenuCategory
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                                onTap: onToggle,
                                child: SvgPicture.asset(
                                  "assets/icons/open_drop_menu_icon.svg",
                                )),
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: categoryMenu.map((toElement) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: GestureDetector(
                                    onTap: () {
                                      onTapMenuElem(toElement);
                                    },
                                    child: Text(
                                      toElement,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.sp),
                                    ),
                                  ),
                                );
                              }).toList()),
                        ],
                      ),
                    )
                  : Row(
                      children: [
                        Text(currentState,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp)),
                        const Spacer(),
                        GestureDetector(
                            onTap: onToggle,
                            child: SvgPicture.asset(
                                "assets/icons/drop_menu_icon.svg")),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget descriptionTextFieldForm(
      String description,
      double widthContainer,
      TextEditingController myController,
      Color title,
      Color container,
      Color stroke,
      FocusNode focus) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: SizedBox(
            width: widthContainer,
            child: Text(
              description,
              style: TextStyle(
                  fontSize: 15.sp, color: title, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Container(
          height: 108.h,
          width: widthContainer,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              color: container,
              border: Border.all(color: stroke, width: 2.w)),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextField(
                maxLines: null,
                focusNode: focus,
                controller: myController,
                decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: '',
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 16.sp)),
                keyboardType: TextInputType.multiline,
                cursorColor: title,
                style: TextStyle(
                    color: title, fontWeight: FontWeight.bold, fontSize: 16.sp),
                onChanged: (text) {},
              )),
        ),
      ],
    );
  }
}
