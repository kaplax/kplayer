import 'package:flutter/material.dart';

class CenterTapDetector extends StatefulWidget {
  const CenterTapDetector(
      {super.key, required this.child, required this.onCenterTap});

  final Widget child;
  final void Function() onCenterTap;

  @override
  State<CenterTapDetector> createState() => _CenterTapDetectorState();
}

class _CenterTapDetectorState extends State<CenterTapDetector> {
  Offset? _tapPosition;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double centerX = screenSize.width / 2;
    final double centerY = screenSize.height / 2;
    const double areaSize = 100.0;

    return GestureDetector(
        onTapDown: (TapDownDetails details) {
          _tapPosition = details.globalPosition;
        },
        onTap: () {
          if (_tapPosition != null) {
            final double tapX = _tapPosition!.dx;
            final double tapY = _tapPosition!.dy;
            if (tapX > centerX - areaSize &&
                tapX < centerX + areaSize &&
                tapY > centerY - areaSize &&
                tapY < centerY + areaSize) {
              widget.onCenterTap();
            }
          }
        },
        child: widget.child);
  }
}
