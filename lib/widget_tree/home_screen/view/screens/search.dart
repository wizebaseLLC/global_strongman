import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light, child: Container()),
      appBar: PlatformAppBar(
        //leading: Container(),
        automaticallyImplyLeading: false,
        cupertino: (_, __) => CupertinoNavigationBarData(),
        trailingActions: [
          Padding(
            padding: EdgeInsets.only(
              left: Platform.isIOS ? kSpacing : 0,
            ),
            child: PlatformTextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.lightBlueAccent),
              ),
              onPressed: () => Navigator.pop(context),
              cupertino: (_, __) => CupertinoTextButtonData(
                padding: EdgeInsets.zero,
              ),
            ),
          )
        ],
        title: PlatformWidget(
          cupertino: (_, __) => CupertinoSearchTextField(
            autofocus: true,
            onChanged: (value) {
              print('The text has changed to: $value');
            },
            onSubmitted: (value) {
              print('Submitted text: $value');
            },
          ),
          material: (_, __) => Hero(
            tag: "search",
            child: Material(
              color: Colors.transparent,
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  filled: true,
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                  ),
                  hintText: "Search",
                  fillColor: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
