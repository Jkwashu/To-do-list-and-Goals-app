import 'package:flutter/material.dart';

class AddGoalDialog extends StatefulWidget {
  final Function(String, String, TextEditingController) onGoalAdded;

  const AddGoalDialog({super.key, required this.onGoalAdded});

  @override
  State<AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<AddGoalDialog> {
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Goal'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _goalController,
            decoration: const InputDecoration(hintText: 'Goal Name'),
          ),
          TextField(
            controller: _deadlineController,
            decoration:
                const InputDecoration(hintText: 'Deadline (YYYY-MM-DD)'),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_goalController.text.isEmpty ||
                _deadlineController.text.isEmpty) {
              setState(() {
                _errorMessage = 'Please enter both a goal and a deadline.';
              });
              return;
            }
            // Clear error if both fields are filled
            setState(() {
              _errorMessage = null;
            });

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
