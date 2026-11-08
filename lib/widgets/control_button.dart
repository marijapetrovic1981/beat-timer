import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'neumorphic_container.dart';

class ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? iconColor;
  final double size;
  final bool isPrimary;
  final Color? glowColor;

  const ControlButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor,
    this.size = 64,
    this.isPrimary = false,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      onPressed: onPressed,
      size: size,
      isCircle: true,
      glowColor: isPrimary ? (glowColor ?? AppTheme.colorWork) : null,
      child: Icon(
        icon,
        color: iconColor ?? 
            (isPrimary ? AppTheme.colorWork : AppTheme.textPrimary),
        size: size * 0.45,
      ),
    );
  }
}
