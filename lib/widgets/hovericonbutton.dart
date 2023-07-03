import 'package:flutter/material.dart';

class HoverIconButton extends StatefulWidget {
  final IconData icon;
  final double scaleFactor;
  final VoidCallback? onPressed;
  const HoverIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.scaleFactor = 1.2,
  });

  @override
  State<HoverIconButton> createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<HoverIconButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..scale(isPressed ? widget.scaleFactor : 1.0),
        child: Icon(
          widget.icon,
          size: 32.0,
        ),
      ),
    );
  }
}
