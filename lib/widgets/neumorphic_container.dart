import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Neumorphic container with raised or pressed effect
class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool isPressed;
  final double? width;
  final double? height;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding,
    this.margin,
    this.isPressed = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (isPressed) {
      // Pressed/inset effect using inner shadow simulation
      return Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowDark,
              offset: const Offset(
                AppTheme.shadowOffsetSmall,
                AppTheme.shadowOffsetSmall,
              ),
              blurRadius: AppTheme.shadowBlurSmall,
            ),
            BoxShadow(
              color: AppTheme.shadowLight,
              offset: const Offset(
                -AppTheme.shadowOffsetSmall,
                -AppTheme.shadowOffsetSmall,
              ),
              blurRadius: AppTheme.shadowBlurSmall,
            ),
          ],
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.shadowDark.withValues(alpha: 0.5),
                AppTheme.background,
                AppTheme.shadowLight.withValues(alpha: 0.3),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: child,
        ),
      );
    }

    // Raised effect
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          // Bottom-right dark shadow
          BoxShadow(
            color: AppTheme.shadowDark,
            offset: const Offset(
              AppTheme.shadowOffset,
              AppTheme.shadowOffset,
            ),
            blurRadius: AppTheme.shadowBlur,
          ),
          // Top-left light shadow
          BoxShadow(
            color: AppTheme.shadowLight,
            offset: const Offset(
              -AppTheme.shadowOffset,
              -AppTheme.shadowOffset,
            ),
            blurRadius: AppTheme.shadowBlur,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Neumorphic button with press animation
class NeumorphicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double size;
  final bool isCircle;
  final Color? glowColor;

  const NeumorphicButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.size = 64,
    this.isCircle = true,
    this.glowColor,
  });

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final decoration = widget.isCircle
        ? BoxDecoration(
            color: AppTheme.background,
            shape: BoxShape.circle,
            boxShadow: _isPressed
                ? [] // No shadow when pressed
                : [
                    BoxShadow(
                      color: AppTheme.shadowDark,
                      offset: const Offset(
                        AppTheme.shadowOffsetSmall,
                        AppTheme.shadowOffsetSmall,
                      ),
                      blurRadius: AppTheme.shadowBlurSmall,
                    ),
                    BoxShadow(
                      color: AppTheme.shadowLight,
                      offset: const Offset(
                        -AppTheme.shadowOffsetSmall,
                        -AppTheme.shadowOffsetSmall,
                      ),
                      blurRadius: AppTheme.shadowBlurSmall,
                    ),
                    if (widget.glowColor != null)
                      BoxShadow(
                        color: widget.glowColor!.withValues(alpha: 0.3),
                        blurRadius: 15,
                        spreadRadius: 0,
                      ),
                  ],
          )
        : BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isPressed
                ? []
                : [
                    BoxShadow(
                      color: AppTheme.shadowDark,
                      offset: const Offset(
                        AppTheme.shadowOffsetSmall,
                        AppTheme.shadowOffsetSmall,
                      ),
                      blurRadius: AppTheme.shadowBlurSmall,
                    ),
                    BoxShadow(
                      color: AppTheme.shadowLight,
                      offset: const Offset(
                        -AppTheme.shadowOffsetSmall,
                        -AppTheme.shadowOffsetSmall,
                      ),
                      blurRadius: AppTheme.shadowBlurSmall,
                    ),
                  ],
          );

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.size,
        height: widget.size,
        decoration: decoration,
        transform: _isPressed
            ? Matrix4.translationValues(2, 2, 0)
            : Matrix4.identity(),
        child: Center(child: widget.child),
      ),
    );
  }
}
