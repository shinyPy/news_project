import 'package:flutter/material.dart';
import 'package:news_project/screen/IntroductionScreen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _fadeAnimation;
  Animation<double>? _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.elasticOut, // This curve provides a spring-like effect
      ),
    );

    _controller!.forward();

    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => IntroductionScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation!,
        child: ScaleTransition(
          scale: _scaleAnimation!,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/icon1.png', // Path to your custom image
                  width: 100, // Adjust the width as needed
                ), // Your logo here
                Text('SKATEL NEWS', style: TextStyle(fontSize: 24.0)),
                const SizedBox(
                  height: 50,
                ),
                LoadingAnimationWidget.flickr(
                  leftDotColor: const Color(0xFF1A1A3F),
                  rightDotColor: const Color(0xFFEA3799),
                  size: 35,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
