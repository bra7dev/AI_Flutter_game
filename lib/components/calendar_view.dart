import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../constants/constants.dart';

class HorizontalCalendarView extends StatefulWidget {
  final Function(DateTime?, DateTime) onDaySelected;

  const HorizontalCalendarView({super.key, required this.onDaySelected, required this.onTodayTap});
  final VoidCallback onTodayTap;
  @override
  _HorizontalCalendarViewState createState() => _HorizontalCalendarViewState();
}

class _HorizontalCalendarViewState extends State<HorizontalCalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime? _selectedDay;
  @override
  void initState() {
    _selectedDay = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16) +
                EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: AppColors.darkGrey3),
            child: TableCalendar(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _selectedDay ?? DateTime.now(),
              calendarFormat: _calendarFormat,
              weekendDays: [],
              dayHitTestBehavior: HitTestBehavior.opaque,
              daysOfWeekHeight: 30,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                    color: AppColors.white, fontWeight: FontWeight.bold),
              ),
              calendarBuilders: CalendarBuilders(
                headerTitleBuilder: (context, day) {
                  return Container(
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          DateFormat.yMMMM().format(day),
                          textAlign: TextAlign.right,
                        )),
                        SizedBox(
                          width: 60,
                        ),
                        Visibility(
                          maintainState: true,
                          maintainSize: true,
                          maintainAnimation: true,
                          visible: !isSameDay(_selectedDay, DateTime.now()),
                          child: TextButton(
                            onPressed: () {
                              widget.onTodayTap();
                              setState(() {
                                _selectedDay = DateTime.now();
                              });
                            },
                            child: Text('Today'),
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 12),
                                minimumSize: Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                side: BorderSide(color: AppColors.white)),
                          ),
                        )
                      ],
                    ),
                  );
                },
                todayBuilder: (context, day, __) {
                  return Container(
                    color: Colors.transparent,
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: AppColors.white.withOpacity(.8),
                        ),
                      ),
                    ),
                  );
                },
                dowBuilder: (context, day) {
                  return isSameDay(_selectedDay, day)
                      ? Container(
                          child: Center(
                            child: Text(
                              DateFormat.E().format(day),
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: AppColors.darkGrey1,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  topLeft: Radius.circular(12))),
                        )
                      : null;
                },
                selectedBuilder: (context, date, selectedDate) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.darkGrey1,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        child: Center(
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(
                                color: AppColors.darkGrey3,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: AppColors.grey1),
                      ),
                    ),
                  );
                },
              ),
              headerStyle: HeaderStyle(
                leftChevronVisible: false,
                rightChevronVisible: false,
                titleCentered: true,
                formatButtonVisible: false,
              ),
              onDaySelected: (selectedDay, focusedDay) {
                widget.onDaySelected(selectedDay, focusedDay);
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                  });
                }
              },
              onFormatChanged: (format) {},
              onPageChanged: (focusedDay) {},
            ),
          ),
        ],
      ),
    );
  }
}
