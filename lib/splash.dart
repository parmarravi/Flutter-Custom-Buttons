import 'package:buttons/home.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _leftAnimation;
  late Animation<double> _rightAnimation;
  double screenWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    )..forward().then((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (screenWidth == 0) {
            screenWidth = constraints.maxWidth;
            _leftAnimation =
                Tween<double>(end: 0, begin: -screenWidth / 2).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            );
            _rightAnimation =
                Tween<double>(end: 0, begin: screenWidth / 2).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            );
          }

          return Stack(
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Positioned(
                    left: _leftAnimation.value,
                    right: -_rightAnimation.value,
                    top: 0,
                    bottom: 0,
                    child: Container(
                        width: 30, // Width of the vertical line
                        color: Colors.white),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
