import 'package:flutter/material.dart';

class SimpleRoute extends PageRoute<dynamic> {
  SimpleRoute({
    required String name,
    required String title,
    required WidgetBuilder builder,
    required bool animated,
    bool solid = true,
  })  : _title = title,
        _builder = builder,
        _animated = animated,
        _solid = solid,
        super(settings: RouteSettings(name: name));

  final String _title;
  final WidgetBuilder _builder;

  final bool _animated;
  final bool _solid;

  @override
  bool get opaque => _solid;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 250);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _animated
        ? FadeTransition(
            opacity: animation,
            child: Title(
              title: _title,
              color: Theme.of(context).primaryColor,
              child: _builder(context),
            ),
          )
        : Title(
            title: _title,
            color: Theme.of(context).primaryColor,
            child: _builder(context),
          );
  }
}
