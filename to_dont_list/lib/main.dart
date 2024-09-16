// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/item.dart';
import 'package:to_dont_list/objects/goal.dart';
import 'package:to_dont_list/widgets/to_do_items.dart';
import 'package:to_dont_list/widgets/to_do_dialog.dart';
import 'package:to_dont_list/widgets/GoalListItem.dart';
import 'package:to_dont_list/widgets/AddGoalDialog.dart';

class ToDoGoalApp extends StatefulWidget {
  const ToDoGoalApp({super.key});

  @override
  State createState() => _ToDoGoalAppState();
}

class _ToDoGoalAppState extends State<ToDoGoalApp> {
  final List<Item> items = [const Item(name: "add more goals")];
  final List<Goal> goals = [
    Goal(name: "Finish Flutter project", deadline: "2024-9-16")
  ];
  final _itemSet = <Item>{};
  final _goalSet = <Goal>{};

  int _selectedIndex = 0;

  void _handleListChanged(Item item, bool completed) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.
      items.remove(item);
      if (!completed) {
        print("Completing");
        _itemSet.add(item);
        items.add(item);
      } else {
        print("Making Undone");
        _itemSet.remove(item);
        items.insert(0, item);
      }
    });
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      print("Deleting item");
      items.remove(item);
    });
  }

  void _handleNewItem(String itemText, TextEditingController textController) {
    setState(() {
      print("Adding new item");
      Item item = Item(
          name:
              itemText); // Error: switched to using itemText instead of string.
      items.insert(0, item);
      textController.clear();
    });
  }

  //Handlers for Goals
  void _handleGoalListChanged(Goal goal, bool completed) {
    setState(() {
      goals.remove(goal);
      if (!completed) {
        _goalSet.add(goal);
        goals.add(goal);
      } else {
        _goalSet.remove(goal);
        goals.insert(0, goal);
      }
    });
  }

  void _handleDeleteGoal(Goal goal) {
    setState(() {
      goals.remove(goal);
    });
  }

  void _handleNewGoal(
      String goalText, String deadline, TextEditingController textcontroller) {
    setState(() {
      Goal goal = Goal(name: goalText, deadline: deadline);
      goals.insert(0, goal);
      textcontroller.clear();
    });
  }

  // Render body based on selected tab
  Widget _buildBody() {
    if (_selectedIndex == 0) {
      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: items.map((item) {
          return ToDoListItem(
            item: item,
            completed: _itemSet.contains(item),
            onListChanged: _handleListChanged,
            onDeleteItem: _handleDeleteItem,
          );
        }).toList(),
      );
    } else {
      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: goals.map((goal) {
          return GoalListItem(
            goal: goal,
            completed: _goalSet.contains(goal),
            onListChanged: _handleGoalListChanged,
            onDeleteGoal: _handleDeleteGoal,
          );
        }).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _selectedIndex == 0
            ? const Text('To Do List')
            : const Text('Goals'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return _selectedIndex == 0
                  ? ToDoDialog(onListAdded: _handleNewItem)
                  : AddGoalDialog(onGoalAdded: _handleNewGoal);
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'To Do'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Goals'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'To Do & Goal Tracker',
    home: ToDoGoalApp(),
  ));
}
