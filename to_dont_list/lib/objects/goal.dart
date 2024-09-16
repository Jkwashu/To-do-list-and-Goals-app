// file to store new goal class

class Goal {
  String name;
  String deadline; // Might switch to use DateTime
  bool completed;
  double progress;

  Goal({
    required this.name,
    required this.deadline,
    this.completed = false,
    this.progress = 0.0,
  }) {
    if (deadline.isEmpty) {
      throw ArgumentError('Deadline cannot be empty');
    }
  }

  //New abbrev class for goals
  String abbrev() {
    if (name.trim().isEmpty) {
      return '';
    }
    List<String> words = name.trim().split(' ');
    String abbreviation = words.map((word) => word[0].toUpperCase()).join();

    return abbreviation;
  }

  // A method to mark the goal as completed
  void markComplete() {
    if (!completed) {
      completed = true;
      progress = 100.0;
    }
  }

  // A method to update the progress
  bool updateProgress(double newProgress) {
    if (newProgress >= 0.0 && newProgress <= 100.0) {
      progress = newProgress;
      return true;
    }
    print("Invalid progress value: $newProgress. Must be between 0 and 100.");
    return false;
  }
}
