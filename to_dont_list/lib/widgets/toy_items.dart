import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/toy.dart';

typedef ToyListChangedCallback = Function(Toy toy, bool completed);
typedef ToyListRemovedCallback = Function(Toy toy);

class ToyListItem extends StatelessWidget {
  ToyListItem(
      {required this.toy,
      required this.got,
      required this.onListChanged,
      required this.onDeleteItem})
      : super(key: ObjectKey(toy));

  final Toy toy;
  final bool got;

  final ToyListChangedCallback onListChanged;
  final ToyListRemovedCallback onDeleteItem;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return got //
        ? Colors.black54
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!got) return null;

    return const TextStyle(
      color: Colors.black54,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onListChanged(toy, got);
      },
      onLongPress: got
          ? () {
              onDeleteItem(toy);
            }
          : null,
      leading: got ? null : CircleAvatar(
        backgroundColor: toy.color,
      ),
      title: Text(
        toy.name,
        style: _getTextStyle(context),
      ),
    );
  }
}
