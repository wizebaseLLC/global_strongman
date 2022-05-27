import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/widget_tree/home_screen/view/screens/search.dart';

class PlatformSliverAppBarWithSearch extends StatelessWidget {
  const PlatformSliverAppBarWithSearch({
    Key? key,
  }) : super(key: key);

  void _handlePlatformSearchRoute(BuildContext context, FocusNode focusNode) {
    focusNode.unfocus();
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => const SearchScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    return PlatformWidget(
      cupertino: (_, __) => CupertinoSliverNavigationBar(
        transitionBetweenRoutes: true,
        middle: const Text("Global Strongman"),
        largeTitle: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: CupertinoSearchTextField(
            focusNode: focusNode,
            onTap: () => _handlePlatformSearchRoute(context, focusNode),
          ),
        ),
        //middle: const Text('Global Strongman'),
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.asset(
            "assets/images/global_strongman_logo.png",
            cacheHeight: 154,
          ),
        ),
      ),
      material: (_, __) => SliverAppBar(
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.none,
          titlePadding: const EdgeInsets.symmetric(horizontal: 0),
          title: Hero(
            tag: "search",
            child: Material(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                focusNode: focusNode,
                onTap: () => _handlePlatformSearchRoute(context, focusNode),
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
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
