import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/firebase_user.dart';
import 'package:global_strongman/core/controller/platformPicker.dart';
import 'package:global_strongman/core/view/platform_scaffold_ios_sliver_title.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/profile_image_view.dart';

class ProgressPhotoScreen extends StatefulWidget {
  const ProgressPhotoScreen({
    required this.file,
    required this.firebaseUser,
    Key? key,
  }) : super(key: key);

  final FirebaseUser firebaseUser;
  final File file;

  @override
  State<ProgressPhotoScreen> createState() => _ProgressPhotoScreenState();
}

class _ProgressPhotoScreenState extends State<ProgressPhotoScreen> {
  String? weight;
  String? bust;
  String? bmi;
  String? waist;
  String? hip;
  String? bodyFat;
  String? description;
  DateTime date = DateTime.now();

  @override
  void initState() {
    setState(() {
      weight = widget.firebaseUser.weight;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffoldIosSliverTitle(
      title: "Progress Photo",
      trailingActions: [
        _buildAppBarTextButton(context),
      ],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(kSpacing * 2),
              child: PlatformTextButton(
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileImageView(
                        heroTag: "Progress Photo",
                        title: "Progress Photo",
                        imageProvider: FileImage(
                          widget.file,
                        )),
                  ),
                ),
                child: Hero(
                  tag: "Progress Photo",
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.file(
                      widget.file,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.laughWink,
                color: Colors.yellowAccent,
              ),
              dense: true,
              title: PlatformTextField(
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
                material: (_, __) => MaterialTextFieldData(
                  decoration: const InputDecoration(
                    label: Text("Say Something"),
                    border: InputBorder.none,
                  ),
                ),
                cupertino: (_, __) => CupertinoTextFieldData(
                  placeholder: "Say Something",
                  decoration: BoxDecoration(
                    border: Border.all(width: 0),
                  ),
                ),
              ),
              tileColor: platformThemeData(
                context,
                material: (data) => data.scaffoldBackgroundColor,
                cupertino: (data) => data.scaffoldBackgroundColor,
              ),
            ),
            const Divider(
              indent: kSpacing * 8,
              color: Colors.grey,
            ),
            _buildListTile(
              context: context,
              title: "Date",
              leading: const FaIcon(
                FontAwesomeIcons.calendarDay,
                color: Colors.amberAccent,
              ),
              trailing: Text(
                DateTime(date.year, date.month, date.day)
                    .toString()
                    .substring(0, 10),
                style: platformThemeData(
                  context,
                  material: (data) => data.textTheme.subtitle1,
                  cupertino: (data) => data.textTheme.navTitleTextStyle,
                ),
              ),
              onPress: () async {
                final picker = PlatformPicker(list: []);

                await picker.showDateTimePicker(
                  context: context,
                  title: "Date",
                  message: "What was the date when you took this picture?",
                  maxDate: DateTime.now().add(
                    const Duration(days: 1),
                  ),
                );

                print(picker.dateTimeValue);
                if (picker.dateTimeValue != null) {
                  setState(
                    () {
                      date = picker.dateTimeValue!;
                    },
                  );
                }
              },
            ),
            _buildListTile(
              context: context,
              title: "Weight (lbs)",
              leading: const FaIcon(
                FontAwesomeIcons.weight,
                color: Colors.lightBlueAccent,
              ),
              trailing: weight != null
                  ? Text(
                      weight!,
                      style: _platformTextStyle(context),
                    )
                  : Icon(
                      PlatformIcons(context).rightChevron,
                      color: Colors.grey,
                    ),
              onPress: () async {
                final picker = PlatformPicker(
                    pickerValue: widget.firebaseUser.weight,
                    list: [
                      "None",
                      ...[
                        for (var i = 80; i <= 600; i++) i.toString(),
                      ]
                    ]);

                await picker.showPicker(
                  context: context,
                  title: "Weight",
                  message: "What was your weight when you took this picture?",
                );

                setState(
                  () {
                    weight = picker.pickerValue != "None"
                        ? picker.pickerValue
                        : null;
                  },
                );
              },
            ),
            _buildListTile(
              context: context,
              title: "Bust (in)",
              leading: const FaIcon(
                FontAwesomeIcons.tape,
                color: Colors.lightGreenAccent,
              ),
              trailing: bust != null
                  ? Text(
                      bust!,
                      style: _platformTextStyle(context),
                    )
                  : Icon(
                      PlatformIcons(context).rightChevron,
                      color: Colors.grey,
                    ),
              onPress: () async {
                final picker = PlatformPicker(
                  pickerValue: bust,
                  list: [
                    "None",
                    ...[
                      for (var i = 1; i <= 100; i++) i.toString(),
                    ]
                  ],
                );

                await picker.showPicker(
                  context: context,
                  title: "Bust",
                  message: "What was your bust size in inches?",
                );

                setState(
                  () {
                    bust = picker.pickerValue != "None"
                        ? picker.pickerValue
                        : null;
                  },
                );
              },
            ),
            _buildListTile(
              context: context,
              title: "BMI",
              leading: const FaIcon(
                FontAwesomeIcons.tape,
                color: Colors.redAccent,
              ),
              trailing: bmi != null
                  ? Text(
                      bmi!,
                      style: _platformTextStyle(context),
                    )
                  : Icon(
                      PlatformIcons(context).rightChevron,
                      color: Colors.grey,
                    ),
              onPress: () async {
                final picker = PlatformPicker(
                  pickerValue: bmi,
                  list: [
                    "None",
                    ...[
                      for (var i = 1; i <= 29; i++) i.toString(),
                    ],
                    "30+",
                  ],
                );

                await picker.showPicker(
                  context: context,
                  title: "BMI",
                  message: "What was your BMI?",
                );

                setState(
                  () {
                    bmi = picker.pickerValue != "None"
                        ? picker.pickerValue
                        : null;
                  },
                );
              },
            ),
            _buildListTile(
              context: context,
              title: "Waist (in)",
              leading: const FaIcon(
                FontAwesomeIcons.tape,
                color: Colors.orangeAccent,
              ),
              trailing: waist != null
                  ? Text(
                      waist!,
                      style: _platformTextStyle(context),
                    )
                  : Icon(
                      PlatformIcons(context).rightChevron,
                      color: Colors.grey,
                    ),
              onPress: () async {
                final picker = PlatformPicker(
                  pickerValue: waist,
                  list: [
                    "None",
                    ...[
                      for (var i = 1; i <= 49; i++) i.toString(),
                    ],
                    "50+",
                  ],
                );

                await picker.showPicker(
                  context: context,
                  title: "Waist",
                  message: "What was your waist size in inches?",
                );

                setState(
                  () {
                    waist = picker.pickerValue != "None"
                        ? picker.pickerValue
                        : null;
                  },
                );
              },
            ),
            _buildListTile(
              context: context,
              title: "Hip (in)",
              leading: const FaIcon(
                FontAwesomeIcons.tape,
                color: Colors.purpleAccent,
              ),
              trailing: hip != null
                  ? Text(
                      hip!,
                      style: _platformTextStyle(context),
                    )
                  : Icon(
                      PlatformIcons(context).rightChevron,
                      color: Colors.grey,
                    ),
              onPress: () async {
                final picker = PlatformPicker(
                  pickerValue: hip,
                  list: [
                    "None",
                    ...[
                      for (var i = 1; i <= 49; i++) i.toString(),
                    ],
                    "50+",
                  ],
                );

                await picker.showPicker(
                  context: context,
                  title: "Hip",
                  message: "What was your hip size in inches?",
                );

                setState(
                  () {
                    hip = picker.pickerValue != "None"
                        ? picker.pickerValue
                        : null;
                  },
                );
              },
            ),
            _buildListTile(
              context: context,
              title: "Body Fat (%)",
              leading: const FaIcon(
                FontAwesomeIcons.percent,
                color: Colors.indigo,
              ),
              trailing: bodyFat != null
                  ? Text(
                      bodyFat!,
                      style: _platformTextStyle(context),
                    )
                  : Icon(
                      PlatformIcons(context).rightChevron,
                      color: Colors.grey,
                    ),
              onPress: () async {
                final picker = PlatformPicker(
                  pickerValue: bodyFat,
                  list: [
                    "None",
                    ...[
                      for (var i = 1; i <= 29; i++) i.toString(),
                    ],
                    "30+",
                  ],
                );

                await picker.showPicker(
                  context: context,
                  title: "Body Fat",
                  message: "What was your Body Fat %",
                );

                setState(
                  () {
                    bodyFat = picker.pickerValue != "None"
                        ? picker.pickerValue
                        : null;
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  TextStyle? _platformTextStyle(BuildContext context) => platformThemeData(
        context,
        material: (data) => data.textTheme.subtitle1?.copyWith(
          color: Colors.grey,
        ),
        cupertino: (data) => data.textTheme.textStyle.copyWith(
          color: Colors.grey,
        ),
      );

  Widget _buildListTile({
    required BuildContext context,
    required Widget leading,
    required String title,
    required Widget trailing,
    required Function() onPress,
  }) {
    return Column(
      children: [
        ListTile(
          leading: leading,
          dense: true,
          title: Text(
            title,
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.subtitle1,
              cupertino: (data) => data.textTheme.navTitleTextStyle,
            ),
          ),
          trailing: trailing,
          onTap: onPress,
          tileColor: platformThemeData(
            context,
            material: (data) => data.scaffoldBackgroundColor,
            cupertino: (data) => data.scaffoldBackgroundColor,
          ),
        ),
        const Divider(
          indent: kSpacing * 8,
          color: Colors.grey,
          height: 1,
        )
      ],
    );
  }

  Widget _buildAppBarTextButton(BuildContext context) {
    return PlatformTextButton(
      child: const Text(
        "Save",
        style: TextStyle(color: Colors.lightBlueAccent),
      ),
      onPressed: () => {},
      cupertino: (_, __) => CupertinoTextButtonData(
        padding: EdgeInsets.zero,
      ),
    );
  }
}
