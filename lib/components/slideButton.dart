import 'dart:math';

import 'package:flutter/material.dart';

class SliderButton extends StatefulWidget {
  final double height = 50;
  final animationDuration = const Duration(milliseconds: 300);
  final String? text;
  final Function() onSlided;
  final bool enabled;
  final SliderButtonController? controller;
  final Color backgroundColor;
  final Color sliderColor;
  final Color textColor;
  const SliderButton({
    required this.onSlided,
    this.text,
    this.controller,
    this.enabled = true,
    this.backgroundColor = Colors.blue,
    this.sliderColor = Colors.lightBlue,
    this.textColor = Colors.white,
  }) : super();

  @override
  State<SliderButton> createState() => _SliderButtonState();
}

class SliderButtonController extends ChangeNotifier {
  void reset() {
    notifyListeners();
  }
}

class _SliderButtonState extends State<SliderButton>
    with SingleTickerProviderStateMixin {
  double _sliderRelativePosition = 0.0; // values 0 -> 1
  double _startedDraggingAtX = 0.0;
  late final AnimationController _animationController;
  late final Animation _sliderAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller!.addListener(reset);
    }
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _sliderAnimation =
        CurveTween(curve: Curves.easeInQuad).animate(_animationController);

    _animationController.addListener(() {
      setState(() {
        _sliderRelativePosition = _sliderAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void reset() {
    _animationController.reverse(from: _sliderRelativePosition);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(_radius),
        border: _border,
      ),
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          final sliderRadius = widget.height / 2;
          final sliderMaxX = constraints.hasBoundedWidth
              ? constraints.maxWidth - 2 * sliderRadius
              : 0.0;
          final sliderPosX = sliderMaxX * _sliderRelativePosition;

          return Stack(
            children: [
              _buildBackground(
                  width: constraints.hasBoundedWidth ? constraints.maxWidth : 0,
                  backgroundSplitX: sliderPosX + sliderRadius),
              _buildText(),
              _buildSlider(sliderMaxX: sliderMaxX, sliderPositionX: sliderPosX),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBackground(
      {required double width, required double backgroundSplitX}) {
    return Row(
      children: [
        Container(
          height: widget.height,
          width: backgroundSplitX,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.only(topLeft: _radius, bottomLeft: _radius),
            color: widget.enabled
                ? this.widget.textColor
                : Theme.of(context).disabledColor,
          ),
        ),
        Container(
          height: widget.height,
          width: width - backgroundSplitX,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.only(topRight: _radius, bottomRight: _radius),
            color: widget.enabled
                ? this.widget.backgroundColor
                : Theme.of(context).disabledColor,
          ),
        ),
      ],
    );
  }

  Widget _buildText() {
    if (widget.text == null) {
      return const SizedBox();
    }
    return SizedBox(
      height: widget.height,
      child: Center(
        child: Text(
          widget.text!,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: widget.textColor,
              ),
        ),
      ),
    );
  }

  Widget _buildSlider(
      {required double sliderMaxX, required double sliderPositionX}) {
    return Positioned(
      left: sliderPositionX,
      child: GestureDetector(
        onHorizontalDragStart: (start) {
          if (!widget.enabled) {
            return;
          }
          _startedDraggingAtX = sliderPositionX;
          _animationController.stop();
        },
        onHorizontalDragUpdate: (update) {
          if (!widget.enabled) {
            return;
          }
          final newSliderPositionX =
              _startedDraggingAtX + update.localPosition.dx;
          final newSliderRelativePosition = newSliderPositionX / sliderMaxX;
          setState(() {
            _sliderRelativePosition = max(0, min(1, newSliderRelativePosition));
          });
        },
        onHorizontalDragEnd: (end) {
          if (!widget.enabled) {
            return;
          }
          if (_sliderRelativePosition == 1.0) {
            widget.onSlided();
          } else {
            reset();
          }
        },
        child: Container(
          height: widget.height,
          width: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(_radius),
            color: widget.enabled
                ? this.widget.sliderColor
                : Theme.of(context).disabledColor,
            border: _border,
          ),
        ),
      ),
    );
  }

  Radius get _radius => Radius.circular(widget.height);
  Border get _border => Border.all(color: Theme.of(context).shadowColor);
}
