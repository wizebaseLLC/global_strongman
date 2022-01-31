import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';

class AnimatedSliverListWrapper extends StatefulWidget {
  const AnimatedSliverListWrapper({
    Key? key,
    this.dense,
    required this.onTap,
    required this.list,
  }) : super(key: key);
  final Function(int index) onTap;
  final bool? dense;
  final ListModel<WorkoutSetListItem> list;
  @override
  State<AnimatedSliverListWrapper> createState() =>
      _AnimatedSliverListWrapperState();
}

class _AnimatedSliverListWrapperState extends State<AnimatedSliverListWrapper> {
  @override
  void initState() {
    super.initState();

    widget.list.removedItemBuilder = _buildRemovedItem;
  }

  // Used to build list items that haven't been removed.
  Widget _buildItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    return CardItem(
      insert: () => _insert(widget.list.length),
      index: index,
      remove: _remove,
      animation: animation,
      item: widget.list.items[index],
      onTap: widget.onTap,
      dense: widget.dense,
      isFirst: index == 0,
      isLast: index == widget.list.length - 1,
    );
  }

  // Used to build an item after it has been removed from the list. This
  // method is needed because a removed item remains visible until its
  // animation has completed (even though it's gone as far this ListModel is
  // concerned). The widget will be used by the
  // [AnimatedListState.removeItem] method's
  // [AnimatedListRemovedItemBuilder] parameter.
  Widget _buildRemovedItem(
    int item,
    BuildContext context,
    Animation<double> animation,
  ) {
    return CardItem(
      remove: _remove,
      onTap: widget.onTap,
      index: item,
      insert: () => _insert(item),
      animation: animation,
      item: widget.list.items[item - 1],
      dense: widget.dense,
      isFirst: item == 0,
      isLast: item == widget.list.length - 1,
    );
  }

  // Insert the "next item" into the list model.
  void _insert(int index) {
    widget.list.insert(index, WorkoutSetListItem());
  }

  // Remove the selected item from the list model.
  void _remove(int index) {
    widget.list.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      key: widget.list.listKey,
      initialItemCount: widget.list.length,
      itemBuilder: _buildItem,
    );
  }
}

typedef RemovedItemBuilder = Widget Function(
  int item,
  BuildContext context,
  Animation<double> animation,
);

// Keeps a Dart [List] in sync with an [AnimatedList].
//
// The [insert] and [removeAt] methods apply to both the internal list and
// the animated list that belongs to [listKey].
//
// This class only exposes as much of the Dart List API as is needed by the
// sample app. More list methods are easily added, however methods that
// mutate the list must make the same changes to the animated list in terms
// of [AnimatedListState.insertItem] and [AnimatedList.removeItem].
class ListModel<WorkoutSetListItem> {
  ListModel({
    required this.listKey,
    required this.items,
    this.removedItemBuilder,
    List<WorkoutSetListItem>? initialItems,
  });

  final GlobalKey<SliverAnimatedListState> listKey;
  RemovedItemBuilder? removedItemBuilder;
  final List<WorkoutSetListItem> items;

  SliverAnimatedListState get _animatedList => listKey.currentState!;

  void insert(int index, WorkoutSetListItem item) {
    items.insert(items.length, item);
    _animatedList.insertItem(items.length - 1);
  }

  WorkoutSetListItem removeAt(int index) {
    final WorkoutSetListItem removedItem = items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(index, (
        BuildContext context,
        Animation<double> animation,
      ) {
        if (removedItemBuilder != null) {
          return removedItemBuilder!(index, context, animation);
        } else {
          return Container();
        }
      });
    }
    return removedItem;
  }

  int get length => items.length;

  //E operator [](int index) => items[index];

  int indexOf(WorkoutSetListItem item) => items.indexOf(item);
}

// Displays its integer item as 'Item N' on a Card whose color is based on
// the item's value.
//
// The card turns gray when [selected] is true. This widget's height
// is based on the [animation] parameter. It varies as the animation value
// transitions from 0.0 to 1.0.
class CardItem extends StatelessWidget {
  const CardItem({
    Key? key,
    this.dense = false,
    required this.index,
    required this.onTap,
    required this.animation,
    required this.item,
    required this.insert,
    required this.remove,
    required this.isFirst,
    required this.isLast,
  }) : super(key: key);

  final Animation<double> animation;
  final Function(int index) onTap;
  final WorkoutSetListItem item;
  final Function(int index) remove;
  final Function() insert;
  final int index;
  final bool? dense;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 1.0,
      ),
      child: SlideTransition(
        position: animation.drive(
          Tween(
            begin: const Offset(2, 0.0),
            end: const Offset(0.0, 0.0),
          ).chain(
            CurveTween(
              curve: Curves.easeIn,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: platformThemeData(
              context,
              material: (data) => data.cardColor,
              cupertino: (data) => data.barBackgroundColor,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isFirst ? kSpacing : 0),
              topRight: Radius.circular(isFirst ? kSpacing : 0),
              bottomLeft: Radius.circular(isLast ? kSpacing : 0),
              bottomRight: Radius.circular(isLast ? kSpacing : 0),
            ),
          ),
          child: ListTile(
            onTap: () => onTap(index),
            title: Text(
              "Set ${index + 1}",
              style: platformThemeData(
                context,
                material: (data) => data.textTheme.subtitle1,
                cupertino: (data) => data.textTheme.textStyle.copyWith(
                  fontSize: 16,
                ),
              ),
            ),
            dense: dense,
            trailing: index == 0
                ? _trailingRow(
                    context: context,
                    item: item,
                    child: TrailingIconButton(
                      fn: insert,
                      icon: PlatformIcons(context).addCircled,
                    ),
                  )
                : _trailingRow(
                    context: context,
                    item: item,
                    child: TrailingIconButton(
                      fn: () {
                        remove(index);
                        // removeFromState(index);
                      },
                      icon: PlatformIcons(context).removeCircled,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _trailingRow({
    required BuildContext context,
    required Widget child,
    required WorkoutSetListItem item,
  }) {
    String value = "";
    switch (item.measurement) {
      case "lbs":
        value = "${item.working_weight_lbs}";
        break;
      case "kgs":
        value = "${item.working_weight_kgs}";
        break;
      case "seconds":
        value = "${item.seconds}";
        break;
      default:
        break;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        item.measurement != null
            ? Text(
                "$value ${item.measurement}",
                style: platformThemeData(
                  context,
                  material: (data) => data.textTheme.subtitle1,
                  cupertino: (data) => data.textTheme.textStyle.copyWith(
                    fontSize: 16,
                  ),
                ),
              )
            : Icon(
                PlatformIcons(context).rightChevron,
                color: Colors.white,
              ),
        child,
      ],
    );
  }
}

class TrailingIconButton extends StatelessWidget {
  const TrailingIconButton({
    Key? key,
    required this.fn,
    required this.icon,
  }) : super(key: key);

  final Function() fn;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return PlatformWidgetBuilder(
      cupertino: (_, child, __) => child,
      material: (_, child, __) => Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: Ink(
          child: InkWell(
            splashColor: kPrimaryColor,
            borderRadius: BorderRadius.circular(60),
            onTap: fn,
            child: child,
          ),
        ),
      ),
      child: PlatformIconButton(
        padding: EdgeInsets.zero,
        material: (context, platform) => MaterialIconButtonData(
          color: Colors.white,
          disabledColor: Colors.white,
        ),
        icon: Icon(
          icon,
        ),
        onPressed: Platform.isIOS ? fn : null,
      ),
    );
  }
}
