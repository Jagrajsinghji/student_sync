import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Page<dynamic> buildPage(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}
