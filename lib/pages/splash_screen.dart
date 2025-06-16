import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  int _seconds = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds--;
      });

      if (_seconds <= 0) {
        _timer?.cancel();
        _goNext();
      }
    });
  }

  void _goNext() {
    if (mounted) {
      context.replaceNamed('home');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景图全屏铺满
          Positioned.fill(
            child: Image.asset(
              'assets/image/run.png', // 你自己的背景图路径
              fit: BoxFit.cover,
            ),
          ),

          // 中心动画内容
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/image/lycoris recoil.webp',
                      width: 180,
                      height: 180,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Otaku Movie',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // 改成白色更适合深色背景
                        shadows: [Shadow(blurRadius: 5, color: Colors.black87, offset: Offset(0, 1))],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 右上角跳过按钮 + 倒计时
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: _goNext,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '跳过 $_seconds',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
