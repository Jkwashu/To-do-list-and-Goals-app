import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:to_dont_list/main.dart';
import 'package:to_dont_list/objects/goal.dart';
import 'package:to_dont_list/widgets/goal_list_item.dart';

// Test for Goal class
void main() {
  group('Goal Class Tests', () {
    // Test the abbreviation method
    test('Goal abbreviation should be first letter', () {
      var goal = Goal(
          name: "Finish Flutter project", deadline: DateTime(2024, 12, 31));
      expect(goal.abbrev(), "F");
    });

    // Test the abbreviation with an empty name
    test('Goal abbreviation with empty name should return empty string', () {
      var goal = Goal(name: "", deadline: DateTime(2024, 12, 31));
      expect(goal.abbrev(), "");
    });

    // Test creating a goal with missing deadline (should throw error)
    test('Goal creation with missing deadline should throw error', () {
      expect(
        () => Goal(
            name: "Incomplete goal",
            deadline: DateTime.now().subtract(const Duration(days: 1))),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('GoalListItem Widget Tests', () {
    // Test that tapping GoalListItem toggles completion status
    testWidgets('Tapping GoalListItem toggles completion status',
        (tester) async {
      final goal = Goal(name: 'Test Goal', deadline: DateTime(2024, 12, 31));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: GoalListItem(
            goal: goal,
            completed: goal.completed,
            onListChanged: (updatedGoal, isCompleted) {
              goal.completed = isCompleted;
            },
            onDeleteGoal: (_) {},
          ),
        ),
      ));

      await tester.tap(find.byType(ListTile));
      await tester.pump();

      expect(goal.completed, true); // Verify completion status changed
    });
    // Test that GoalListItem renders correctly
    testWidgets('GoalListItem has a text', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: GoalListItem(
                  goal: Goal(
                      name: "Finish Flutter project",
                      deadline: DateTime(2024, 12, 31)),
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
                      name: "Finish Flutter project",
                      deadline: DateTime(2024, 12, 31)),
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
                      name: "Finish Flutter project",
                      deadline: DateTime(2024, 12, 31)),
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
      // Render the app
      await tester
          .pumpWidget(const MaterialApp(home: Scaffold(body: ToDoGoalApp())));

      await tester.tap(find.text('Goals'));
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('goalTextField')), 'Complete Testing');
      await tester.enterText(
          find.byKey(const Key('deadlineTextField')), '2024-12-31');
      await tester.pump();

      await tester.tap(find.byKey(const Key("OKButton")));
      await tester.pumpAndSettle();

      expect(find.byType(GoalListItem), findsNWidgets(2));
      expect(find.text('Complete Testing'), findsOneWidget);
    });

    // Test that goal input dialog throws error when no deadline is set
    testWidgets('AddGoalDialog shows error for missing input', (tester) async {
      await tester
          .pumpWidget(const MaterialApp(home: Scaffold(body: ToDoGoalApp())));

      await tester.tap(find.text('Goals'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle(); // Open the dialog

      // Attempt to press OK without setting the deadline
      await tester.tap(find.byKey(const Key("OKButton")));
      await tester.pumpAndSettle();

      // Verify that error is shown for missing deadline
      expect(find.text("Please enter both a goal and a deadline."),
          findsOneWidget);

      await tester.enterText(
          find.byKey(const Key('goalTextField')), 'Test Goal');
      await tester.tap(find.byKey(const Key("OKButton")));
      await tester.pumpAndSettle();

      // Check that the error message is still displayed
      expect(find.text('Please enter both a goal and a deadline.'),
          findsOneWidget);
    });

    // Test that goal input dialog shows error for missing goal name or deadline
    testWidgets('AddGoalDialog shows error for missing goal name or deadline',
        (tester) async {
      await tester
          .pumpWidget(const MaterialApp(home: Scaffold(body: ToDoGoalApp())));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle(); // Open the dialog

      // Enter goal name but not deadline
      await tester.enterText(find.byType(TextField).first, 'New Goal');
      await tester.pump();

      // Attempt to press Add without setting the deadline
      await tester.tap(find.byKey(const Key("OKButton")));
      await tester.pumpAndSettle();

      // Verify that error message is shown for missing deadline
      expect(find.text("Please enter both a goal and a deadline."),
          findsOneWidget);
    });
  });

  group('Goal Integration Tests', () {
    // Test that clicking and typing adds a goal to GoalList
    testWidgets('Clicking and Typing adds goal to GoalList', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ToDoGoalApp()));

      await tester.tap(find.text('Goals'));
      await tester.pumpAndSettle();

      // Tap the FloatingActionButton to open the AddGoalDialog
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle(); // Wait for the dialog to open fully

      // Enter a goal name
      await tester.enterText(
          find.byKey(const Key('goalTextField')), 'New Goal');
      await tester.enterText(
          find.byKey(const Key('deadlineTextField')), '2024-12-31');
      await tester.pump(); // Ensure the text is entered

      // Tap the "OKButton" to add the goal
      await tester.tap(find.byKey(const Key("OKButton")));
      await tester
          .pumpAndSettle(); // Wait for the dialog to close and list to update

      // Verify that the new goal is added to the list
      expect(find.text("New Goal"), findsOneWidget);
      expect(find.byType(GoalListItem),
          findsNWidgets(2)); // Includes the default goal
    });

    // Test that long pressing a completed goal deletes it
    testWidgets('Long pressing a completed goal deletes it', (tester) async {
      bool deleted = false;
      final goal =
          Goal(name: 'Completed Goal', deadline: DateTime(2024, 12, 31));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: GoalListItem(
            goal: goal,
            completed: true,
            onListChanged: (_, __) {},
            onDeleteGoal: (_) {
              deleted = true;
            },
          ),
        ),
      ));

      await tester.longPress(find.byType(ListTile));
      expect(deleted, true); // Verify that the goal was deleted
    });

    // Test that deleting a goal works
    testWidgets('Deleting a goal removes it from the list', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ToDoGoalApp()));

      await tester.tap(find.text('Goals'));
      await tester.pumpAndSettle();

      expect(find.byType(GoalListItem), findsOneWidget);

      final deleteIcon = find.byIcon(Icons.delete);
      expect(deleteIcon, findsOneWidget);
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      expect(find.byType(GoalListItem), findsNothing);
    });
  });
}
