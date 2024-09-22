import 'package:flutter/material.dart';

enum SideColor {
  red(Colors.red), 
  purple(Color.fromARGB(255, 136, 18, 182)),
  grey(Color.fromARGB(255, 94, 94, 94));

  const SideColor(this.rgbcolor);

  final Color rgbcolor;
}

class Toy {
  Toy({required this.name, required this.color});

  final String name;
  final SideColor color;
  bool got = false;

  void isGot(bool b) {
    got = b;
  }
}