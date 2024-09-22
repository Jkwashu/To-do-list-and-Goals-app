import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/Toy.dart';

typedef ToDoListChangedCallback = Function(Toy toy, bool completed);
typedef ToDoListRemovedCallback = Function(Toy toy);

class ToyListItem extends StatelessWidget {
  ToyListItem(
      {required this.toy,
      required this.completed,
      required this.onListChanged,
      required this.onDeleteItem})
      : super(key: ObjectKey(toy));

  final Toy toy;
  final bool completed;

  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return completed //
        ? Colors.black54
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!completed) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onListChanged(toy, completed);
      },
      onLongPress: completed
          ? () {
              onDeleteItem(toy);
            }
          : null,
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
      ),
      title: Text(
        toy.name,
        style: _getTextStyle(context),
      ),
    );
  }
}
