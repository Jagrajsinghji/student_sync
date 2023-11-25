import 'package:flutter/material.dart';

class Skill {
  // {
  // "_id": "653047be82b58f30260bb6da",
  // "name": "Cooking"
  // },
  final String id;
  final String name;

  ValueNotifier<bool> isSelected = ValueNotifier(false);

  Skill._({required this.id, required this.name});

  factory Skill.fromMap(Map data) {
    return Skill._(id: data['_id'], name: data['name'])
      ..isSelected.value = false;
  }
}
