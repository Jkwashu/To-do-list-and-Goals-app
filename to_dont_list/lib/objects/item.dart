// Data class to keep the string and have an abbreviation function

class Item {
  const Item({required this.name});

  final String name;

  // Fixed the abbreviation to return only the first letter
  String abbrev() {
    return name.isNotEmpty ? name[0] : '';
  }
}
