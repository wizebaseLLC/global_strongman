import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/view/platform_scaffold_ios_sliver_title.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/profile_image_view.dart';

class ProgressPhotoScreen extends StatelessWidget {
  const ProgressPhotoScreen({required this.file, Key? key}) : super(key: key);

  final File file;

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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileImageView(
                          heroTag: "Progress Photo",
                          title: "Progress Photo",
                          imageProvider: FileImage(
                            file,
                          )),
                    ),
                  ),
                  child: Hero(
                    tag: "Progress Photo",
                    child: Image.file(
                      file,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade800.withOpacity(.5),
                  ),
                ),
              ),
              child: ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.laughWink,
                  color: Colors.yellowAccent,
                ),
                dense: true,
                title: PlatformTextField(
                  autofocus: true,
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
            ),
            _buildListTile(
              context: context,
              title: "Weight (lbs)",
              leading: const FaIcon(
                FontAwesomeIcons.weight,
                color: Colors.lightBlueAccent,
              ),
              trailing: Icon(
                PlatformIcons(context).rightChevron,
                color: Colors.grey,
              ),
              onPress: () {},
            ),
            _buildListTile(
              context: context,
              title: "Bust (in)",
              leading: const FaIcon(
                FontAwesomeIcons.tape,
                color: Colors.lightGreenAccent,
              ),
              trailing: Icon(
                PlatformIcons(context).rightChevron,
                color: Colors.grey,
              ),
              onPress: () {},
            ),
            _buildListTile(
              context: context,
              title: "BMI",
              leading: const FaIcon(
                FontAwesomeIcons.tape,
                color: Colors.redAccent,
              ),
              trailing: Icon(
                PlatformIcons(context).rightChevron,
                color: Colors.grey,
              ),
              onPress: () {},
            ),
            _buildListTile(
              context: context,
              title: "Waist (in)",
              leading: const FaIcon(
                FontAwesomeIcons.tape,
                color: Colors.orangeAccent,
              ),
              trailing: Icon(
                PlatformIcons(context).rightChevron,
                color: Colors.grey,
              ),
              onPress: () {},
            ),
            _buildListTile(
              context: context,
              title: "Hip (in)",
              leading: const FaIcon(
                FontAwesomeIcons.tape,
                color: Colors.purpleAccent,
              ),
              trailing: Icon(
                PlatformIcons(context).rightChevron,
                color: Colors.grey,
              ),
              onPress: () {},
            ),
            _buildListTile(
              context: context,
              title: "Body Fat (%)",
              leading: const FaIcon(
                FontAwesomeIcons.percent,
                color: Colors.indigo,
              ),
              trailing: Icon(
                PlatformIcons(context).rightChevron,
                color: Colors.grey,
              ),
              onPress: () {},
            ),
            _buildListTile(
              context: context,
              title: "Date",
              leading: const FaIcon(
                FontAwesomeIcons.calendarDay,
                color: Colors.amberAccent,
              ),
              trailing: Icon(
                PlatformIcons(context).rightChevron,
                color: Colors.grey,
              ),
              onPress: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required Widget leading,
    required String title,
    required Widget trailing,
    required Function() onPress,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade800.withOpacity(.5),
          ),
        ),
      ),
      child: ListTile(
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
