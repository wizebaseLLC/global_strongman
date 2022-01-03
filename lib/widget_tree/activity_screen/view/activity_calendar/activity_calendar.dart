import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/widget_tree/activity_screen/model/activity_interface.dart';
import 'package:table_calendar/table_calendar.dart';

class ActivityCalendar extends StatelessWidget {
  const ActivityCalendar({
    required this.activityInterface,
    Key? key,
  }) : super(key: key);
  final ActivityInterface activityInterface;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.now(),
      focusedDay: DateTime.now(),
      onDaySelected: (selectedDay, focusedDay) =>
          print("$selectedDay - $focusedDay"),
      // daysOfWeekStyle:
      //     const DaysOfWeekStyle(decoration: BoxDecoration(color: Colors.white)),
      calendarStyle: const CalendarStyle(
        defaultTextStyle: TextStyle(color: Colors.white),
        weekendTextStyle: TextStyle(color: Colors.white),
        outsideTextStyle: TextStyle(color: Colors.white),
      ),
      headerStyle:
          const HeaderStyle(titleTextStyle: TextStyle(color: Colors.white)
              // decoration: BoxDecoration(color: Colors.white)
              ),
    );
  }
}
