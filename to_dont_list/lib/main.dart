// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/item.dart';
import 'package:to_dont_list/objects/goal.dart';
import 'package:to_dont_list/widgets/to_do_items.dart';
import 'package:to_dont_list/widgets/to_do_dialog.dart';
import 'package:to_dont_list/widgets/goal_list_item.dart';
import 'package:to_dont_list/widgets/add_goal_dialog.dart';

class ToDoGoalApp extends StatefulWidget {
  const ToDoGoalApp({super.key});

  @override
  State createState() => _ToDoGoalAppState();
}

class _ToDoGoalAppState extends State<ToDoGoalApp> {
  final List<Item> items = [const Item(name: "add more goals")];
  final List<Goal> goals = [
    Goal(
        name: "Finish Flutter project",
        deadline: DateTime.now().add(const Duration(days: 30)))
  ];
  final _itemSet = <Item>{};
  final _goalSet = <Goal>{};

  int _selectedIndex = 0;

  void _handleListChanged(Item item, bool completed) {
    setState(() {
      items.remove(item);
      if (!completed) {
        _itemSet.add(item);
        items.add(item);
      } else {
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
      if (itemText.isNotEmpty) {
        Item item = Item(name: itemText);
        items.insert(0, item);
        textController.clear();
      } else {
        print("Item text cannot be empty");
      }
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

  void _handleNewGoal(String goalText, DateTime deadline,
      TextEditingController textController) {
    setState(() {
      Goal goal = Goal(name: goalText, deadline: deadline);
      goals.insert(0, goal);
      textController.clear();
    });
  }

  // Render body based on selected tab
  Widget _buildBody() {
    if (_selectedIndex == 0) {
      // To-Do Items
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
      // Goals 
      final DateTime now = DateTime.now();
      final List<Goal> longTermGoals = goals
          .where((goal) => goal.deadline.isAfter(now.add(const Duration(days: 30))))
          .toList();
      final List<Goal> shortTermGoals = goals
          .where((goal) => !goal.deadline.isAfter(now.add(const Duration(days: 30))))
          .toList();

      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: [
          if (shortTermGoals.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Short-Term Goals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ...shortTermGoals.map((goal) {
            return GoalListItem(
              goal: goal,
              completed: _goalSet.contains(goal),
              onListChanged: _handleGoalListChanged,
              onDeleteGoal: _handleDeleteGoal,
            );
          }),
          if (longTermGoals.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Long-Term Goals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ...longTermGoals.map((goal) {
            return GoalListItem(
              goal: goal,
              completed: _goalSet.contains(goal),
              onListChanged: _handleGoalListChanged,
              onDeleteGoal: _handleDeleteGoal,
            );
          }),
        ],
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
