import 'package:flutter/material.dart';

class Stamp extends StatefulWidget {
  const Stamp(
    this.imageUrl, {
    super.key,
    this.width = 150.0,
    this.locked = false,
    this.onClick,
  });

  final String imageUrl;
  final double width;
  final bool locked;
  final VoidCallback? onClick;

  final double aspectRatio = 1.5333333;
  final double relativeHoleRadius = 1.0;

  @override
  State<Stamp> createState() => _StampState();
}

class _StampState extends State<Stamp> {
  @override
  Widget build(BuildContext context) {
    final double width = widget.width;
    final double height = width * widget.aspectRatio;
    final double holeRadius = widget.relativeHoleRadius * (width / 10.0);

    return GestureDetector(
      onTap: widget.onClick,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.tight(Size(width, height)),
          child: Material(
            elevation: 8.0,
            color: Colors.transparent,
            child: _clippedNetwork(width, height, holeRadius),
          ),
        ),
      ),
    );
  }

  Widget _clippedNetwork(
    double cardWidth,
    double cardHeight,
    double holeRadius,
  ) {
    final List<Widget> stackChildren = <Widget>[
      Image.network(
        widget.imageUrl,
        width: cardWidth,
        height: cardHeight,
        fit: BoxFit.cover,
      ),
    ];

    if (widget.locked) {
      stackChildren.add(
        Container(
          color: const Color(0xbb000000),
          width: cardWidth,
          height: cardHeight,
        ),
      );

      stackChildren.add(
        const Align(
          alignment: Alignment.center,
          child: Icon(Icons.lock, color: Colors.white),
        ),
      );
    }

    return ClipPath(
      clipper: StampClipper(holeRadius: holeRadius),
      child: Container(
        color: Colors.white,
        child: Stack(children: stackChildren),
      ),
    );
  }
}

class StampClipper extends CustomClipper<Path> {
  StampClipper({this.holeRadius = 15.0});

  final double holeRadius;

  @override
  Path getClip(Size size) {
    final Path path = Path();

    int num = (size.width / holeRadius).round();
    if (num.isEven) num++;

    double radius = size.width / num;

    for (int i = 0; i < num ~/ 2; i++) {
      path.relativeLineTo(radius, 0);
      path.relativeArcToPoint(
        Offset(radius, 0),
        radius: Radius.circular(radius / 2),
        clockwise: false,
      );
    }

    path.relativeLineTo(0, size.height);

    for (int i = 0; i < num ~/ 2; i++) {
      path.relativeLineTo(-radius, 0);
      path.relativeArcToPoint(
        Offset(-radius, 0),
        radius: Radius.circular(radius / 2),
        clockwise: false,
      );
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant StampClipper oldClipper) {
    return oldClipper.holeRadius != holeRadius;
  }
}
