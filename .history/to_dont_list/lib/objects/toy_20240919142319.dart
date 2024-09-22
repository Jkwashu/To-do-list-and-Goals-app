import 'package:flutter/material.dart';

enum SideColor {
  autobot(Colors.red), 
  decepticon(Color.fromARGB(255, 136, 18, 182)),
  other(Color.fromARGB(255, 94, 94, 94));

  const SideColor(this.rgbcolor);

  final Color rgbcolor;
}

class Toy {
  const Toy({required this.name, required this.color});

  final String name;
  final SideColor color;
  // // bool got = false;

  // void isGot(bool b) {
  //   got = b;
  // }
}