import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/goal.dart';

typedef GoalListChangedCallback = Function(Goal goal, bool completed);
typedef GoalListRemovedCallback = Function(Goal goal);

class GoalListItem extends StatelessWidget {
  const GoalListItem({
    required this.goal,
    required this.completed,
    required this.onListChanged,
    required this.onDeleteGoal,
    super.key,
  });

  final Goal goal;
  final bool completed;

  final GoalListChangedCallback onListChanged;
  final GoalListRemovedCallback onDeleteGoal;

  Color _getColor(BuildContext context) {
    return completed ? Colors.green : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!completed) return null;
    return const TextStyle(
      color: Colors.grey,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onListChanged(goal, completed);
      },
      onLongPress: completed
          ? () {
              onDeleteGoal(goal);
            }
          : null,
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(goal.name.substring(0, 1)), // Use first letter of goal name
      ),
      title: Text(
        goal.name,
        style: _getTextStyle(context),
      ),
    );
  }
}
