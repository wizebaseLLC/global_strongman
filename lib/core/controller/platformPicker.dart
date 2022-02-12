import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_strongman/constants.dart';
import 'package:duration_picker/duration_picker.dart';

class PlatformPicker {
  PlatformPicker({required this.list, this.pickerValue});

  final List<String> list;
  String? pickerValue;
  DateTime? dateTimeValue;
  Duration? timerPickerValue;

  static String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

// TODO Add a previous value for android.
  Future<void> showPicker({
    required BuildContext context,
    required String title,
    String? message,
  }) async {
    if (Platform.isIOS) {
      pickerValue ??= list[0];
      await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          final FixedExtentScrollController? scrollController =
              pickerValue != null
                  ? FixedExtentScrollController(
                      initialItem: list.indexOf(pickerValue!),
                    )
                  : null;
          return CupertinoActionSheet(
            title: Text(
              title,
              style: CupertinoTheme.of(context)
                  .textTheme
                  .navTitleTextStyle
                  .copyWith(fontSize: 20),
            ),
            message: message != null
                ? Text(
                    message,
                    style:
                        CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                  )
                : null,
            cancelButton: CupertinoActionSheetAction(
              isDestructiveAction: true,
              child: const Text(
                'Done',
                style: TextStyle(color: CupertinoColors.activeBlue),
              ),
              onPressed: () {
                scrollController?.dispose();
                Navigator.pop(context);
              },
            ),
            actions: [createCupertinoPicker(scrollController)],
          );
        },
      );
    } else {
      await showModalBottomSheet(
        context: context,
        enableDrag: true,
        isDismissible: true,
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        // ),
        isScrollControlled: true,
        builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height * .65,
          child: createMaterialPicker(
            title: title,
            message: message,
            context: context,
            initialValue: pickerValue,
          ),
        ),
      );
    }
  }

  Future<void> showDurationTimerPicker({
    required BuildContext context,
    required String title,
    String? message,
  }) async {
    if (Platform.isIOS) {
      await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          final FixedExtentScrollController? scrollController =
              pickerValue != null
                  ? FixedExtentScrollController(
                      initialItem: list.indexOf(pickerValue!),
                    )
                  : null;
          return CupertinoActionSheet(
            title: Text(
              title,
              style: CupertinoTheme.of(context)
                  .textTheme
                  .navTitleTextStyle
                  .copyWith(fontSize: 20),
            ),
            message: message != null
                ? Text(
                    message,
                    style:
                        CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                  )
                : null,
            cancelButton: CupertinoActionSheetAction(
              isDestructiveAction: true,
              child: const Text(
                'Done',
                style: TextStyle(color: CupertinoColors.activeBlue),
              ),
              onPressed: () {
                scrollController?.dispose();
                Navigator.pop(context);
              },
            ),
            actions: [createCupertinoTimerPicker()],
          );
        },
      );
    } else {
      final Duration? resultingDuration = await showDurationPicker(
          context: context,
          initialTime: const Duration(minutes: 0),
          baseUnit: BaseUnit.second,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ));

      timerPickerValue = resultingDuration;
    }
  }

  Future<void> showDateTimePicker({
    required BuildContext context,
    required String title,
    String? message,
    DateTime? maxDate,
  }) async {
    if (Platform.isIOS) {
      await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text(
              title,
              style: CupertinoTheme.of(context)
                  .textTheme
                  .navTitleTextStyle
                  .copyWith(fontSize: 20),
            ),
            message: message != null
                ? Text(
                    message,
                    style:
                        CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                  )
                : null,
            cancelButton: CupertinoActionSheetAction(
              isDestructiveAction: true,
              child: const Text(
                'Done',
                style: TextStyle(color: Colors.lightBlueAccent),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [createCupertinoDateTimePicker(maxDate)],
          );
        },
      );
    } else {
      final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2015, 8),
        lastDate: maxDate ?? DateTime(2101),
        initialDate: DateTime.now(),
      );

      if (picked != null) {
        dateTimeValue = picked;
      }
    }
  }

  Widget createMaterialPicker({
    required BuildContext context,
    required String title,
    String? initialValue,
    String? message,
  }) {
    final ScrollController? scrollController = initialValue != null
        ? ScrollController(
            initialScrollOffset: list.indexOf(initialValue) * 52,
          )
        : null;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(kSpacing),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        if (message != null)
          Padding(
            padding: const EdgeInsets.all(kSpacing),
            child: Text(
              message,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: list.length,
            itemBuilder: (context, index) => Column(
              children: [
                SizedBox(
                  height: 50,
                  child: ListTile(
                    title: Text(
                      list[index],
                      style: const TextStyle(fontSize: 18),
                    ),
                    dense: true,
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      pickerValue = list[index];
                      scrollController?.dispose();
                      Navigator.pop(context);
                    },
                  ),
                ),
                const Divider(
                  indent: kSpacing * 2,
                  height: 2,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget createCupertinoTimerPicker() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            child: CupertinoTimerPicker(
              onTimerDurationChanged: (value) {
                timerPickerValue = value;
              },
              mode: CupertinoTimerPickerMode.hms,
            ),
          ),
        ],
      );

  Widget createCupertinoPicker(FixedExtentScrollController? scrollController) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            child: CupertinoPicker(
              itemExtent: 48,
              onSelectedItemChanged: (value) {
                pickerValue = list[value];
              },
              scrollController: scrollController,
              children: list
                  .map((e) => Center(
                        child: Text(
                          e,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      );

  Widget createCupertinoDateTimePicker(DateTime? maxDate) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              maximumDate: maxDate,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (value) {
                dateTimeValue = value;
              },
            ),
          ),
        ],
      );
}
