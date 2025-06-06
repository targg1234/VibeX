import 'package:flutter/material.dart';

class SlideFadeTransition extends StatelessWidget {
  final AnimationController animation;
  final int index;
  final Widget child;

  const SlideFadeTransition({
    super.key,
    required this.animation,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(
          (index * 0.1).clamp(0.0, 1.0),
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );

    final fadeAnimation = CurvedAnimation(
      parent: animation,
      curve: Interval(
        (index * 0.1).clamp(0.0, 1.0),
        1.0,
        curve: Curves.easeIn,
      ),
    );

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: child,
      ),
    );
  }
}
