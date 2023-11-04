import 'package:flutter/material.dart';

class Skill {
  final String id;
  final String name;

  ValueNotifier<bool> isSelected = ValueNotifier(false);

  Skill({required this.id, required this.name});
}
