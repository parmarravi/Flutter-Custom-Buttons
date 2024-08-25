import 'package:flutter/material.dart';
import 'dart:math' as math;

enum ButtonState { defaultState, loading, completed, disabled }

class CustomLoadingButton extends StatefulWidget {
  final String initialText;
  final String loadingText;
  final TextStyle textStyle;
  final double borderRadius;
  final double borderWidth;
  final Color backgroundColor;
  final Color borderColor;
  final Duration animationDuration;
  final VoidCallback? onTap; // Add the onTap callback
  final ButtonState state;

  const CustomLoadingButton(
      {super.key,
      required this.initialText,
      required this.loadingText,
      this.textStyle = const TextStyle(color: Colors.yellow, fontSize: 18),
      this.borderRadius = 30.0,
      this.borderWidth = 3.0,
      this.backgroundColor = Colors.black,
      this.borderColor = Colors.yellow,
      this.animationDuration = const Duration(seconds: 2),
      this.state = ButtonState.defaultState,
      this.onTap});

  @override
  State<CustomLoadingButton> createState() => _CustomLoadingButtonState();
}

class _CustomLoadingButtonState extends State<CustomLoadingButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    _bounceController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _bounceController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state == ButtonState.loading) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
    return Center(
      child: GestureDetector(
        onTap: widget.state == ButtonState.disabled
            ? null // Disable onTap if the button is in disabled state
            : () {
                _bounceController.forward();
                widget.onTap?.call();
              },
        child: ScaleTransition(
          scale: _bounceAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: widget.state == ButtonState.completed ? 60 : 200,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  widget.state == ButtonState.completed
                      ? 30
                      : widget.borderRadius),
              color: widget.state == ButtonState.disabled
                  ? Colors.grey // Greyed out color for disabled state
                  : (widget.state == ButtonState.completed
                      ? Colors.green
                      : widget.backgroundColor),
              boxShadow: widget.state == ButtonState.loading ||
                      widget.state == ButtonState.completed ||
                      widget.state == ButtonState.disabled
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        offset: const Offset(4, -4),
                        blurRadius: 10,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        offset: const Offset(-4, -4),
                        blurRadius: 10,
                      ),
                    ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (widget.state == ButtonState.loading)
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(
                          8.0), // Adding space between border and button edge
                      child: CustomPaint(
                        painter: GradientCircularBorderPainter(
                          animation: _controller,
                          borderColor: widget.borderColor,
                          borderWidth: widget.borderWidth,
                          borderRadius: widget.borderRadius,
                        ),
                      ),
                    ),
                  ),
                Center(
                  child: widget.state == ButtonState.completed
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 30,
                        )
                      : Text(
                          widget.state == ButtonState.loading
                              ? widget.loadingText
                              : widget.initialText,
                          style: widget.textStyle,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GradientCircularBorderPainter extends CustomPainter {
  final Animation<double> animation;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius; // New parameter for custom radius

  GradientCircularBorderPainter({
    required this.animation,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final adjustedRect = Rect.fromLTWH(
      borderWidth / 2,
      borderWidth / 2,
      size.width - borderWidth,
      size.height - borderWidth,
    );

    final gradient = SweepGradient(
      startAngle: 0.0,
      endAngle: math.pi * 2,
      colors: [
        Colors.transparent,
        borderColor,
        borderColor,
      ],
      stops: const [0.0, 0.5, 1.0],
      transform: GradientRotation(animation.value * math.pi * 2),
    );

    final paint = Paint()
      ..shader = gradient.createShader(adjustedRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..addRRect(
          RRect.fromRectAndRadius(adjustedRect, Radius.circular(borderRadius)));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
