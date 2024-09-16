import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:to_dont_list/main.dart';
import 'package:to_dont_list/objects/goal.dart';
import 'package:to_dont_list/widgets/GoalListItem.dart';

// Test for Goal class
void main() {
  group('Goal Class Tests', () {
    // Test the abbreviation method
    test('Goal abbreviation should be first letter', () {
      var goal = Goal(name: "Finish Flutter project", deadline: "2024-12-31");
      expect(goal.abbrev(), "F");
    });

    // Test the abbreviation with an empty name
    test('Goal abbreviation with empty name should return empty string', () {
      var goal = Goal(name: "", deadline: "2024-12-31");
      expect(goal.abbrev(), "");
    });

    // Test creating a goal with missing deadline (should throw error)
    test('Goal creation with empty deadline should throw error', () {
      expect(
        () => Goal(name: "Incomplete goal", deadline: ""),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('GoalListItem Widget Tests', () {
    // Test that GoalListItem renders correctly
    testWidgets('GoalListItem has a text', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: GoalListItem(
                  goal: Goal(
                      name: "Finish Flutter project", deadline: "2024-12-31"),
                  completed: false,
                  onListChanged: (Goal goal, bool completed) {},
                  onDeleteGoal: (Goal goal) {}))));
      final textFinder = find.text('Finish Flutter project');

      // Verify that the text widget appears exactly once in the widget tree.
      expect(textFinder, findsOneWidget);
    });

    // Test that GoalListItem has a Circle Avatar with abbreviation
    testWidgets('GoalListItem has a Circle Avatar with abbreviation',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: GoalListItem(
                  goal: Goal(
                      name: "Finish Flutter project", deadline: "2024-12-31"),
                  completed: false,
                  onListChanged: (Goal goal, bool completed) {},
                  onDeleteGoal: (Goal goal) {}))));

      final abbvFinder = find.text('F');
      final avatarFinder = find.byType(CircleAvatar);

      CircleAvatar circ = tester.firstWidget(avatarFinder);
      Text ctext = circ.child as Text;

      // Verify that the CircleAvatar contains the abbreviation "F".
      expect(abbvFinder, findsOneWidget);
      expect(ctext.data, "F");
    });

    // Test that a completed goal renders differently (e.g., different color)
    testWidgets('GoalListItem renders completed goal with different style',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: GoalListItem(
                  goal: Goal(
                      name: "Finish Flutter project", deadline: "2024-12-31"),
                  completed: true,
                  onListChanged: (Goal goal, bool completed) {},
                  onDeleteGoal: (Goal goal) {}))));

      final avatarFinder = find.byType(CircleAvatar);
      CircleAvatar circ = tester.firstWidget(avatarFinder);

      // Verify that the CircleAvatar has a different color for completed goals
      expect(circ.backgroundColor, Colors.green);
    });
  });

  group('AddGoalDialog Widget Tests', () {
    // Test that AddGoalDialog appears and adds a goal
    testWidgets('AddGoalDialog appears and adds a goal', (tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: ToDoGoalApp())));

      expect(find.byType(TextField), findsNothing);

      await tester.tap(find.byType(FloatingActionButton));
      await tester
          .pump(); // Pump after the FloatingActionButton tap to open dialog

      expect(find.byType(TextField), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Complete Testing');
      await tester.pump();
      expect(find.text('Complete Testing'), findsOneWidget);

      await tester.tap(find.byKey(const Key("OKButton")));
      await tester.pump();

      final listItemFinder = find.byType(GoalListItem);

      // Check that the new goal has been added to the list
      expect(listItemFinder, findsNWidgets(2)); // Including the default goal
    });

    // Test that goal input dialog throws error when no deadline is set
    testWidgets('AddGoalDialog shows error for missing deadline',
        (tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: ToDoGoalApp())));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump(); // Open the dialog

      await tester.enterText(find.byType(TextField), 'New Goal');
      await tester.pump();

      // Attempt to press OK without setting the deadline
      await tester.tap(find.byKey(const Key("OKButton")));
      await tester.pump();

      // Verify that error is shown for missing deadline
      expect(find.text("Please set a deadline"), findsOneWidget);
    });
  });

  group('Goal Integration Tests', () {
    // Test that clicking and typing adds a goal to GoalList
    testWidgets('Clicking and Typing adds goal to GoalList', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ToDoGoalApp()));

      // Switch to the Goals tab
      await tester.tap(find.text('Goals'));
      await tester.pump();

      expect(find.byType(TextField), findsNothing);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump(); // Pump after every action to rebuild the widgets
      expect(find.text("New Goal"), findsNothing);

      await tester.enterText(find.byType(TextField), 'New Goal');
      await tester.pump();
      expect(find.text("New Goal"), findsOneWidget);

      await tester.tap(find.byKey(const Key("OKButton")));
      await tester.pump();
      expect(find.text("New Goal"), findsOneWidget);

      final listItemFinder = find.byType(GoalListItem);

      expect(listItemFinder, findsNWidgets(2)); // Including the default goal
    });

    // Test that deleting a goal works
    testWidgets('Deleting a goal removes it from the list', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ToDoGoalApp()));

      // Switch to the Goals tab
      await tester.tap(find.text('Goals'));
      await tester.pump();

      final deleteButtonFinder = find.byIcon(Icons.delete);

      // Tap the delete button on the first goal
      await tester.tap(deleteButtonFinder.first);
      await tester.pump();

      final listItemFinder = find.byType(GoalListItem);

      // Expect only one goal left after deletion
      expect(listItemFinder, findsOneWidget);
    });
  });
}
