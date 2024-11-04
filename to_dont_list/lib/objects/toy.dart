import 'package:flutter/material.dart';

enum Faction {
  a('Autobot', Color.fromARGB(255, 255, 0, 0)), 
  d('Decepticon', Color.fromARGB(255, 112, 79, 162)),
  o('Other', Color.fromARGB(255, 128, 128, 128));

  const Faction(this.label, this.rgbcolor);
  final String label;
  final Color rgbcolor;
}

class Toy {
  Toy({required this.name, required this.color});

  final String name;
  final Color color;
}