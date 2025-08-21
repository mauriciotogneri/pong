import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:pong/utils/locator.dart';

class Navigation {
  final Routes routes = Routes();

  static Navigation get _get => locator<Navigation>();

  static Routes get getRoutes => _get.routes;

  static BuildContext get context => _get.routes.key.currentContext!;

  static Route<dynamic>? get currentRoute => _get.routes.current();

  static bool isCurrent(String name) => currentRoute?.settings.name == name;

  static Future<T?>? push<T>(Route<T> route) => _get.routes.push(route);

  static Future<T?>? pushAlone<T>(Route<T> newRoute) =>
      _get.routes.pushAlone(newRoute);

  static Future<T?>? pushReplacement<T>(Route<T> route) =>
      _get.routes.pushReplacement(route);

  static void pop<T>([T? result]) => _get.routes.pop(result);

  static void dialog({required Widget widget, required String name}) {
    if (!isCurrent(name)) {
      getRoutes.push(
        PageRouteBuilder(
          settings: RouteSettings(name: name),
          opaque: false,
          pageBuilder: (context, _, __) => widget,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }
}
