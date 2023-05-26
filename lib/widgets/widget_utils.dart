import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({
    Key? key,
    required Widget child,
    required ValueNotifier<bool> loading,
    Color color = Colors.white,
  })  : _child = child,
        _loading = loading,
        _color = color,
        super(key: key);

  final Widget _child;
  final ValueNotifier<bool> _loading;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _loading,
      builder: (context, loading, _) => Stack(
        children: [
          _child,
          if (loading)
            Container(
              color: Colors.black.withAlpha(0xCC),
              child: Center(
                child: StyledProgressBar(color: _color),
              ),
            ),
        ],
      ),
    );
  }
}

class StyledProgressBar extends StatelessWidget {
  const StyledProgressBar({Key? key, Color color = Colors.white})
      : _color = color,
        super(key: key);
  final Color _color;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(_color),
    );
  }
}


class VSpace extends StatelessWidget {
  final double height;
  const VSpace(this.height, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class HSpace extends StatelessWidget {
  final double width;
  const HSpace(this.width, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}
