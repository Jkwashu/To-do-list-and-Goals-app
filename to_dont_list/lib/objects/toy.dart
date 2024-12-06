import 'package:flutter/material.dart';

enum Faction {
  a('Autobot', Color.fromARGB(255, 255, 0, 0),
      Image(image: AssetImage('assets/images/AutobotLogo.png'))),
  d('Decepticon', Color.fromARGB(255, 112, 79, 162),
      Image(image: AssetImage('assets/images/DecepteconLogo.png'))),
  o('Other', Color.fromARGB(255, 128, 128, 128),
      Image(image: AssetImage('assets/images/QuestionMark.png')));

  const Faction(this.label, this.rgbcolor, this.image);
  final String label;
  final Color rgbcolor;
  final Image image;
}

enum ToyClass { leader, voyager, deluxe, core, masterpiece, other }

class Toy {
  Toy({
    required this.name,
    required this.color,
    required this.faction,
    required this.toyClass,
    required this.toyline,
    required this.releaseYear,
    this.price,
    this.notes,
  });

  final String name;
  final Color color;
  final Faction faction;
  final ToyClass toyClass;
  final String toyline;
  final int releaseYear;
  final double? price;
  final String? notes;

  String getSortKey(ToySortOption sortOption) {
    switch (sortOption) {
      case ToySortOption.name:
        return name.toLowerCase();
      case ToySortOption.faction:
        return faction.label;
      case ToySortOption.toyClass:
        return toyClass.toString();
      case ToySortOption.toyline:
        return toyline;
      case ToySortOption.releaseYear:
        return releaseYear.toString();
      default:
        return name.toLowerCase();
    }
  }
}

enum ToySortOption {
  name,
  faction,
  toyClass,
  toyline,
  releaseYear,
}
