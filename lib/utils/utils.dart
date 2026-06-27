import 'package:flutter/material.dart';

class FadeRoute<T> extends MaterialPageRoute<T> {
  FadeRoute({required WidgetBuilder builder, RouteSettings? settings})
    : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final isInitial = settings.name == Navigator.defaultRouteName;

    if (isInitial) {
      return child;
    }

    return FadeTransition(opacity: animation, child: child);
  }
}
