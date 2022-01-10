import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';
import 'package:global_strongman/widget_tree/activity_screen/model/activity_interface.dart';
import 'package:global_strongman/widget_tree/activity_screen/model/event.dart';
import 'package:table_calendar/table_calendar.dart';

class ActivityCalendar extends StatefulWidget {
  const ActivityCalendar({
    required this.selectedDay,
    required this.activityInterface,
    required this.setActivityScreenState,
    Key? key,
  }) : super(key: key);
  final ActivityInterface activityInterface;
  final void Function(DateTime pickedDate) setActivityScreenState;
  final DateTime selectedDay;
  @override
  State<ActivityCalendar> createState() => _ActivityCalendarState();
}

class _ActivityCalendarState extends State<ActivityCalendar> {
  CalendarFormat format = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Event>> selectedEvents = {};
  late List<FirebaseUserWorkoutComplete> workoutsGroupedByDate;
  List<Event> _getEventsFromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void initState() {
    workoutsGroupedByDate = widget.activityInterface.completedWorkouts
        .map((workout) => FirebaseUserWorkoutComplete(
              categories: workout.categories,
              created_on: normalizeDate(workout.created_on!),
              program_id: workout.program_id,
              seconds: workout.seconds,
              working_weight_kgs: workout.working_weight_kgs,
              working_weight_lbs: workout.working_weight_lbs,
              workout_id: workout.workout_id,
            ))
        .toList();

    for (var element in workoutsGroupedByDate) {
      if (element.created_on != null) {
        if (selectedEvents[element.created_on!] == null) {
          selectedEvents[element.created_on!] = [];
        }
      }
    }

    for (var element in workoutsGroupedByDate) {
      if (element.created_on != null &&
          selectedEvents[element.created_on] != null) {
        selectedEvents[element.created_on]!
            .add(Event(title: element.workout_id!));
      }
    }

    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          availableGestures: AvailableGestures.horizontalSwipe,
          firstDay: DateTime.utc(2022),
          lastDay: DateTime.now(),
          focusedDay: _focusedDay,
          eventLoader: _getEventsFromDay,
          calendarFormat: format,
          onFormatChanged: (_format) => setState(() {
            format = _format;
          }),
          selectedDayPredicate: (day) => isSameDay(widget.selectedDay, day),
          onDaySelected: (pickedDay, focusedDay) {
            widget.setActivityScreenState(pickedDay);
            setState(
              () {
                _focusedDay = focusedDay;
              },
            );
          },
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            markersMaxCount: 1,
            markerDecoration: const BoxDecoration(
              color: Color(0XFFFE7762),
              shape: BoxShape.circle,
            ),
            defaultTextStyle: const TextStyle(
              color: Colors.white,
            ),
            weekendTextStyle: const TextStyle(color: Colors.white),
            outsideTextStyle: const TextStyle(color: Colors.white),
            disabledTextStyle: TextStyle(
              color:
                  Platform.isIOS ? CupertinoColors.systemGrey : Colors.white30,
            ),
            selectedDecoration: const BoxDecoration(
              color: kPrimaryColor,
              shape: BoxShape.circle,
            ),
            todayDecoration: const BoxDecoration(
              color: kSecondaryColor,
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: HeaderStyle(
            titleTextStyle: const TextStyle(color: Colors.white),
            formatButtonTextStyle: const TextStyle(color: Colors.white60),
            formatButtonDecoration: BoxDecoration(
              border: Border.all(
                color: kPrimaryColor,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            formatButtonShowsNext: false,
            titleCentered: true,
          ),
        ),
        const SizedBox(
          height: kSpacing * 2,
        ),
      ],
    );
  }
}
