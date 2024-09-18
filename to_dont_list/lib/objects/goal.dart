// file to store new goal class

class Goal {
  String name;
  DateTime deadline;
  bool completed;
  double progress;

  Goal({
    required this.name,
    required this.deadline,
    this.completed = false,
    this.progress = 0.0,
  }) : assert(
            deadline.isAfter(DateTime.now()), 'Deadline must be in the future');

  //New abbrev method just for goals
  String abbrev() {
    if (name.isNotEmpty) {
      return name[0];
    }
    return '';
  }

  // A method to mark the goal as completed
  void markComplete() {
    completed = true;
    progress = 100.0;
  }

  // A method to update the progress
  void updateProgress(double newProgress) {
    if (newProgress >= 0.0 && newProgress <= 100.0) {
      progress = newProgress;
    }
  }
}
