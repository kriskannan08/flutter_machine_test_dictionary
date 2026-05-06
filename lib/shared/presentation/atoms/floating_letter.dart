import 'package:flutter/material.dart';

class FloatingLetter extends StatelessWidget {
  const FloatingLetter({
    super.key,
    required this.letter,
    required this.position,
    required this.opacity,
  });

  final String letter;
  final Offset position;
  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: FadeTransition(
        opacity: opacity,
        child: Text(
          letter,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.12),
            fontSize: 52,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
