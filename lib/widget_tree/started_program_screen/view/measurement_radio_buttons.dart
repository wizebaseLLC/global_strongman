import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/view_workout_screen.dart';

class MeasurementRadioButtons extends StatelessWidget {
  const MeasurementRadioButtons(
      {Key? key, required this.measurement, required this.setState})
      : super(key: key);
  final Measurement? measurement;
  final Function(Measurement? value) setState;

  MaterialStateColor get _fillColor => MaterialStateColor.resolveWith(
        (state) {
          if (state.contains(MaterialState.selected)) {
            return Platform.isIOS ? CupertinoColors.activeBlue : Colors.blue;
          } else {
            return Platform.isIOS
                ? CupertinoColors.systemGrey3
                : Colors.white60;
          }
        },
      );
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          dense: true,
          title: Text(
            'lbs',
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.bodyText1?.copyWith(
                fontSize: 16,
                color: Colors.white70,
              ),
              cupertino: (data) => data.textTheme.textStyle.copyWith(
                fontSize: 16,
                color: CupertinoColors.systemGrey3,
              ),
            ),
          ),
          leading: Radio<Measurement>(
            activeColor: kPrimaryColor,
            fillColor: _fillColor,
            value: Measurement.lbs,
            groupValue: measurement,
            onChanged: setState,
          ),
        ),
        ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          dense: true,
          title: Text(
            'kgs',
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.bodyText1?.copyWith(
                fontSize: 16,
                color: Colors.white70,
              ),
              cupertino: (data) => data.textTheme.textStyle.copyWith(
                fontSize: 16,
                color: CupertinoColors.systemGrey3,
              ),
            ),
          ),
          leading: Radio<Measurement>(
            fillColor: _fillColor,
            value: Measurement.kgs,
            groupValue: measurement,
            onChanged: setState,
          ),
        ),
        ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          dense: true,
          title: Text(
            'secs',
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.bodyText1?.copyWith(
                fontSize: 16,
                color: Colors.white70,
              ),
              cupertino: (data) => data.textTheme.textStyle.copyWith(
                fontSize: 16,
                color: CupertinoColors.systemGrey3,
              ),
            ),
          ),
          leading: Radio<Measurement>(
            fillColor: _fillColor,
            value: Measurement.seconds,
            groupValue: measurement,
            onChanged: setState,
          ),
        ),
      ],
    );
  }
}
