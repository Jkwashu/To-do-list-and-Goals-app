import 'package:flutter/material.dart';

class AddGoalDialog extends StatefulWidget {
  final Function(String, String, TextEditingController) onGoalAdded;

  AddGoalDialog({required this.onGoalAdded});

  @override
  State<AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<AddGoalDialog> {
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Goal'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _goalController,
            decoration: InputDecoration(hintText: 'Goal Name'),
          ),
          TextField(
            controller: _deadlineController,
            decoration: InputDecoration(hintText: 'Deadline (YYYY-MM-DD)'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onGoalAdded(
              _goalController.text,
              _deadlineController.text,
              _goalController,
            );
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _goalController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }
}
