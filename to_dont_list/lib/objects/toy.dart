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

class Toy {
  Toy({required this.name, required this.color, required this.faction});

  final String name;
  final Color color;
  final Faction faction;
}
