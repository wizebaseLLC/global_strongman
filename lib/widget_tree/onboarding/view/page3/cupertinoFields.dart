import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_strongman/constants.dart';

class CupertinoFormFields extends StatelessWidget {
  const CupertinoFormFields({
    required this.backgroundColor,
    Key? key,
  }) : super(key: key);
  final Color backgroundColor;

  List<Widget> _getHeightList() {
    List<int> feet = [for (var i = 4; i <= 8; i++) i];
    List<int> inches = [for (var i = 1; i <= 11; i++) i];
    List<String> combined = [];
    for (var ft in feet) {
      {
        for (var inc in inches) {
          combined.add("$ft'$inc");
        }
      }
    }

    return combined.map((e) => Text(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection.insetGrouped(
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.all(kSpacing),
      children: [
        CupertinoFormRow(
          prefix: Text(
            'Height',
            style: CupertinoTheme.of(context).textTheme.pickerTextStyle.copyWith(
                  color: Colors.grey,
                ),
          ),
          child: SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width * .6,
            child: CupertinoPicker(
              itemExtent: 30,
              onSelectedItemChanged: (value) {
                print(value + 1);
              },
              children: _getHeightList(),
            ),
          ),
        ),
        CupertinoFormRow(
          prefix: Text(
            'Weight',
            style: CupertinoTheme.of(context).textTheme.pickerTextStyle.copyWith(
                  color: Colors.grey,
                ),
          ),
          child: SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width * .6,
            child: CupertinoPicker(
              itemExtent: 30,
              onSelectedItemChanged: (value) {
                print(value + 1);
              },
              children: [for (var i = 60; i <= 600; i++) Text(i.toString())],
            ),
          ),
        ),
        CupertinoFormRow(
          prefix: Text(
            'Gender',
            style: CupertinoTheme.of(context).textTheme.pickerTextStyle.copyWith(
                  color: Colors.grey,
                ),
          ),
          child: SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width * .6,
            child: CupertinoPicker(
              itemExtent: 30,
              onSelectedItemChanged: (value) {
                print(kGenders[value]);
              },
              children: kGenders.map((gender) => Text(gender)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
