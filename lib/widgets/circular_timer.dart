import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/timer_state.dart';
import '../theme/app_theme.dart';

class CircularTimer extends StatelessWidget {
  final TimerState state;
  final int totalSeconds;
  final double size;

  const CircularTimer({
    super.key,
    required this.state,
    required this.totalSeconds,
    this.size = 300,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalSeconds > 0 
        ? state.secondsRemaining / totalSeconds 
        : 0.0;
    
    final color = _getPhaseColor(state.phase);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Neumorphic base circle
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppTheme.background,
              shape: BoxShape.circle,
              boxShadow: [
                // Outer dark shadow
                BoxShadow(
                  color: AppTheme.shadowDark,
                  offset: const Offset(
                    AppTheme.shadowOffset,
                    AppTheme.shadowOffset,
                  ),
                  blurRadius: AppTheme.shadowBlur,
                ),
                // Outer light shadow
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
          ),
          // Inner pressed circle
          Container(
            width: size - 24,
            height: size - 24,
            decoration: BoxDecoration(
              color: AppTheme.background,
              shape: BoxShape.circle,
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
          ),
          // Progress ring with glow
          CustomPaint(
            size: Size(size - 40, size - 40),
            painter: _GlowingRingPainter(
              progress: progress,
              color: color,
              strokeWidth: 12,
            ),
          ),
          // Timer display
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.phase.displayName.toUpperCase(),
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.formattedTime,
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: size * 0.18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPhaseColor(TimerPhase phase) {
    switch (phase) {
      case TimerPhase.work:
        return AppTheme.colorWork;
      case TimerPhase.rest:
      case TimerPhase.restBetweenCycles:
      case TimerPhase.cooldown:
        return AppTheme.colorRest;
      case TimerPhase.prepare:
        return AppTheme.colorPrepare;
      case TimerPhase.finished:
        return AppTheme.colorWork;
      case TimerPhase.idle:
        return AppTheme.textSecondary;
    }
  }
}

class _GlowingRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _GlowingRingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track
    final trackPaint = Paint()
      ..color = AppTheme.shadowDark
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Glow effect
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = strokeWidth + 16
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        glowPaint,
      );
    }

    // Main progress arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GlowingRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
