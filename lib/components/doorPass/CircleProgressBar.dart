import 'package:flutter/material.dart';
import 'package:scv_app/components/doorPass/CircleProgressBarPainter.dart';

class CircleProgressBar extends StatelessWidget {
  final Color? backgroundColor;
  final Color foregroundColor;
  final double value;
  final double strokeWidth;
  final Widget child;

  const CircleProgressBar({
    Key? key,
    this.backgroundColor,
    required this.foregroundColor,
    required this.value,
    this.strokeWidth = 6,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = this.backgroundColor;
    final foregroundColor = this.foregroundColor;
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        child: Center(child: this.child) ?? Container(),
        foregroundPainter: CircleProgressBarPainter(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            percentage: this.value,
            strokeWidth: this.strokeWidth),
      ),
    );
  }
}
