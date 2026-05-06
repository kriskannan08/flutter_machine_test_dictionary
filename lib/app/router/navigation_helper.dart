import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_router.dart';

extension NavigationHelper on BuildContext {
  void goTo(AppRoute route) {
    go(route.path);
  }

  void pushTo(AppRoute route) {
    push(route.path);
  }

  void replaceTo(AppRoute route) {
    replace(route.path);
  }

  void popRoute() {
    pop();
  }
}
