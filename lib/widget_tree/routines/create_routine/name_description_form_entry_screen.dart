import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_routine.dart';
import 'package:global_strongman/widget_tree/routines/model/name_description_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class NameDescriptionFormEntryScreen extends StatefulWidget {
  const NameDescriptionFormEntryScreen({
    required this.nameDescriptionValue,
    Key? key,
  }) : super(key: key);
  final FirebaseRoutine nameDescriptionValue;
  @override
  State<NameDescriptionFormEntryScreen> createState() =>
      _NameDescriptionFormEntryScreenState();
}

class _NameDescriptionFormEntryScreenState
    extends State<NameDescriptionFormEntryScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  bool _isSaving = false;

  @override
  void initState() {
    nameController =
        TextEditingController(text: widget.nameDescriptionValue.name);
    descriptionController =
        TextEditingController(text: widget.nameDescriptionValue.description);

    nameController.addListener(() => setState(() {}));
    super.initState();
  }

  void _onSubmit() {
    setState(() {
      _isSaving = true;
    });
    final nameDescription = NameDescriptionModel(
      name: nameController.text,
      description: descriptionController.text,
    );
    Navigator.pop(context, nameDescription);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text("Routine"),
        trailingActions: [
          PlatformTextButton(
            padding: EdgeInsets.zero,
            onPressed: nameController.text.isEmpty ? null : _onSubmit,
            child: Text(
              "Save",
              style: platformThemeData(
                context,
                material: (data) => data.textTheme.bodyMedium,
                cupertino: (data) => data.textTheme.actionTextStyle.copyWith(
                  color: nameController.text.isEmpty
                      ? CupertinoColors.systemGrey
                      : CupertinoColors.activeBlue,
                ),
              ),
            ),
          ),
        ],
        cupertino: (_, __) => CupertinoNavigationBarData(
          previousPageTitle: "Create Routine",
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isSaving,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: kSpacing * 2,
              left: kSpacing,
              right: kSpacing,
            ),
            child: Column(
              children: [
                PlatformTextField(
                  controller: nameController,
                  hintText: "Routine Name",
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 20),
                  material: (_, __) => MaterialTextFieldData(
                    decoration: const InputDecoration.collapsed(
                      hintText: "Routine Name",
                    ),
                  ),
                  cupertino: (_, __) => CupertinoTextFieldData(
                    decoration: const BoxDecoration(),
                  ),
                ),
                const SizedBox(
                  height: kSpacing * 2,
                ),
                Flexible(
                  child: PlatformTextField(
                    hintText: "Add a description or expected benefits",
                    controller: descriptionController,
                    textCapitalization: TextCapitalization.sentences,
                    expands: true,
                    minLines: null,
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 14,
                      color: Platform.isIOS
                          ? CupertinoColors.systemGrey
                          : Colors.white70,
                    ),
                    material: (_, __) => MaterialTextFieldData(
                      decoration: const InputDecoration.collapsed(
                        hintText: "Add a description or expected benefits",
                      ),
                    ),
                    cupertino: (_, __) => CupertinoTextFieldData(
                      decoration: const BoxDecoration(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
