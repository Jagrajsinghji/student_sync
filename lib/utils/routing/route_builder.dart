import 'package:flutter/material.dart';

PageRoute buildRoute(Widget child) {
  return PageRouteBuilder(pageBuilder: (c, _, __) {
    return child;
  },);
}
