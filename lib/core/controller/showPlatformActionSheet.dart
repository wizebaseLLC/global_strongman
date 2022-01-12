import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PlatformActionSheet {
  final String title;
  final String? subtitleIos;
  final List<ActionSheetModel> model;

  PlatformActionSheet({
    required this.title,
    this.subtitleIos,
    required this.model,
  });
}

class ActionSheetModel {
  final String title;
  final TextStyle textStyle;
  final Function() onTap;
  final Icon iconMaterial;

  ActionSheetModel({
    required this.title,
    required this.textStyle,
    required this.onTap,
    required this.iconMaterial,
  });
}

/// Displays an action sheet for both Ios and Android
void showPlatformActionSheet({
  required BuildContext context,
  required PlatformActionSheet actionSheetData,
}) {
  showPlatformModalSheet<void>(
    context: context,
    material: MaterialModalSheetData(
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
    ),
    builder: (BuildContext context) => PlatformWidget(
      material: (_, __) => _buildMaterialBottomSheet(context, actionSheetData),
      cupertino: (_, __) =>
          _buildCupertinoActionSheet(context, actionSheetData),
    ),
  );
}

Widget _buildMaterialBottomSheet(
  BuildContext context,
  PlatformActionSheet actionSheetData,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          actionSheetData.title,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
      for (var i in actionSheetData.model)
        ListTile(
          leading: i.iconMaterial,
          title: Text(
            i.title,
            style: i.textStyle,
          ),
          onTap: () {
            Navigator.pop(context);
            i.onTap();
          },
        ),
      ListTile(
        leading: const Icon(Icons.stop_rounded),
        title: const Text(
          'Cancel',
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
}

Widget _buildCupertinoActionSheet(
  BuildContext context,
  PlatformActionSheet actionSheetData,
) {
  return CupertinoActionSheet(
    title: Text(actionSheetData.title),
    message: actionSheetData.subtitleIos != null
        ? Text(actionSheetData.subtitleIos!)
        : null,
    cancelButton: CupertinoActionSheetAction(
      // isDestructiveAction: true,
      child: const Text(
        'Cancel',
        style: TextStyle(
          color: CupertinoColors.systemOrange,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    actions: <CupertinoActionSheetAction>[
      for (var i in actionSheetData.model)
        CupertinoActionSheetAction(
          child: Text(
            i.title,
            style: i.textStyle,
          ),
          onPressed: () {
            Navigator.pop(context);
            i.onTap();
          },
        ),
    ],
  );
}
