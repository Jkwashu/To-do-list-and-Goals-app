import 'package:flutter/material.dart';

typedef GoalListAddedCallback = Function(
    String goalText, TextEditingController textController);

class AddGoalDialog extends StatefulWidget {
  const AddGoalDialog({
    required this.onGoalAdded,
    super.key,
  });

  final GoalListAddedCallback onGoalAdded;

  @override
  State<AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<AddGoalDialog> {
  final TextEditingController _goalController = TextEditingController();
  String goalText = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Goal'),
      content: TextField(
        onChanged: (value) {
          setState(() {
            goalText = value;
          });
        },
        controller: _goalController,
        decoration: const InputDecoration(hintText: "Enter goal here"),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: goalText.isNotEmpty
              ? () {
                  widget.onGoalAdded(goalText, _goalController);
                  Navigator.pop(context);
                }
              : null,
          child: const Text('Add'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
