import 'package:flutter/material.dart';

class BottomNavController {
  final ValueNotifier<int> currentIndex = ValueNotifier(0);

  setIndex(int index) {
    if (index < 0 || index > 3 || selectedIndex == index) return;
    currentIndex.value = index;
  }

  int get selectedIndex => currentIndex.value;
}
