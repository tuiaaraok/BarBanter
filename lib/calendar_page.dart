import 'package:favorite_bars/hive/hive_box.dart';
import 'package:favorite_bars/hive/places_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final PageController _pageController =
      PageController(initialPage: DateTime.now().month - 1);
  TextEditingController startTimeController = TextEditingController();

  DateTime _currentMonth = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable:
              Hive.box<PlacesModel>(HiveBoxes.placesModel).listenable(),
          builder: (context, Box<PlacesModel> box, _) {
            return SizedBox(
              width: double.infinity,
              child: SafeArea(
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
                      "Calendar",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(
                        width: 372.w,
                        height: 450.h,
                        child: myCustomCalendar(
                            startTimeController,
                            box
                                    .get(DateFormat('yy/MM')
                                        .format(_currentMonth))
                                    ?.placesList ??
                                [])),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      width: 324.w,
                      height: 129.h,
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFD465),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.black, width: 2.h),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 4.h), color: Colors.black)
                          ]),
                      child: Center(
                          child: RichText(
                        text: TextSpan(
                            text: "This month you visited establishments",
                            children: [
                              TextSpan(
                                  text:
                                      " ${box.get(DateFormat('yy/MM').format(_currentMonth))?.placesList.length ?? 0} times ",
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        fontSize: 20.84.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red),
                                  )),
                            ],
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  fontSize: 20.84.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            )),
                        textAlign: TextAlign.center,
                      )),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget myCustomCalendar(
      TextEditingController dateController, List<PlaceModel> box) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(_currentMonth),
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_currentMonth.month == 1) {
                          // Если января — переключаемся на декабрь предыдущего года
                          setState(() {
                            _currentMonth =
                                DateTime(_currentMonth.year - 1, 12);
                            _pageController.jumpToPage(
                                11); // Сброс к странице 11 (декабрь предыдущего года)
                          });
                        } else {
                          setState(() {
                            _currentMonth = DateTime(
                              _currentMonth.year,
                              _currentMonth.month - 1,
                            );
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          });
                        }
                      },
                      child: SvgPicture.asset(
                        "assets/icons/arrow_back.svg",
                        width: 24.w,
                        height: 24.h,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_currentMonth.month == 12) {
                          // Если декабря — переключаемся на январь следующего года
                          setState(() {
                            _currentMonth = DateTime(_currentMonth.year + 1, 1);
                            _pageController.jumpToPage(
                                0); // Сброс к странице 0 (январь следующего года)
                          });
                        } else {
                          setState(() {
                            _currentMonth = DateTime(
                              _currentMonth.year,
                              _currentMonth.month + 1,
                            );
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          });
                        }
                      },
                      child: SvgPicture.asset(
                        "assets/icons/arrow_next.svg",
                        width: 24.w,
                        height: 24.h,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentMonth = DateTime(
                    _currentMonth.year,
                    index + 1,
                  );
                });
              },
              itemCount: 12 * 3,
              itemBuilder: (context, pageIndex) {
                return buildCalendar(
                    DateTime(_currentMonth.year, _currentMonth.month, 1),
                    dateController,
                    box);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCalendar(DateTime month, TextEditingController dateController,
      List<PlaceModel> box) {
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    int weekdayOfFirstDay = firstDayOfMonth.weekday;

    List<Widget> calendarCells = [];

    // Добавляем названия дней недели
    List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    for (String day in weekDays) {
      calendarCells.add(
        Container(
          alignment: Alignment.center,
          child: Text(day.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13.28.sp,
                color: const Color(0xFF3C3C43).withValues(alpha: 0.3),
              )),
        ),
      );
    }

    // Добавляем дни предыдущего месяца
    int daysInPreviousMonth = DateTime(month.year, month.month, 0).day;
    int daysToShowFromPreviousMonth = (weekdayOfFirstDay - 1) % 7;

    for (int i = daysInPreviousMonth - daysToShowFromPreviousMonth + 1;
        i <= daysInPreviousMonth;
        i++) {
      DateTime date = DateTime(month.year, month.month, i);
      calendarCells.add(Container(
        decoration: BoxDecoration(
            color: const Color(0xFFFF4949),
            borderRadius: BorderRadius.all(
              Radius.circular(10.r),
            ),
            border: Border.all(width: 2.w, color: Colors.black)),
        child: Center(
          child: Text(
            date.day.toString(),
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20.43.sp),
          ),
        ),
      ));
    }

    // Добавляем дни текущего месяца
    for (int i = 1; i <= daysInMonth; i++) {
      DateTime date = DateTime(month.year, month.month, i);
      calendarCells.add(
        GestureDetector(
          onTap: () {},
          child: Container(
              decoration: BoxDecoration(
                  color: getColorForDate(date, box),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.r),
                  ),
                  border: Border.all(width: 2.w, color: Colors.black)),
              child: Center(
                child: Text(date.day.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 20.43.sp)),
              )),
        ),
      );
    }

    int size = calendarCells.length;

    // Добавляем дни текущего месяца
    for (int i = 1;
        size % 7 != 0 ? i <= (7 * ((size / 7).toInt() + 1)) - size : false;
        i++) {
      DateTime date = DateTime(month.year, month.month, i);
      calendarCells.add(Container(
        decoration: BoxDecoration(
            color: const Color(0xFFFF4949),
            borderRadius: BorderRadius.all(
              Radius.circular(10.r),
            ),
            border: Border.all(width: 2.w, color: Colors.black)),
        child: Center(
          child: Text(
            date.day.toString(),
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20.43.sp),
          ),
        ),
      ));
    }

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 5.0,
      crossAxisCount: 7,
      childAspectRatio: 1,
      children: calendarCells,
    );
  }
}

Color getColorForDate(DateTime date, List<PlaceModel> box) {
  bool dateExists = box.any((test) =>
      DateFormat("dd MM yy").format(test.date) ==
      DateFormat("dd MM yy").format(date));

  return dateExists ? const Color(0xFFFFD465) : const Color(0xFF00A0A6);
}
