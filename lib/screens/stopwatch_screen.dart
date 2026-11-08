import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/workout.dart';

import '../theme/app_theme.dart';
import '../widgets/neumorphic_container.dart';
import '../widgets/control_button.dart';

class StopwatchScreen extends StatefulWidget {
  final Workout workout;

  const StopwatchScreen({
    super.key,
    required this.workout,
  });

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Timer? _timer;
  int _prepareSeconds = 0;
  int _elapsedMilliseconds = 0;
  bool _isPreparing = true;
  bool _isRunning = false;
  bool _isPaused = false;
  final List<int> _laps = [];

  @override
  void initState() {
    super.initState();
    _prepareSeconds = widget.workout.prepareSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    if (_isPreparing) {
      _startPrepareCountdown();
    } else {
      _startStopwatch();
    }
  }

  void _startPrepareCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_prepareSeconds > 1) {
          _prepareSeconds--;
          if (_prepareSeconds <= 3) {
            HapticFeedback.lightImpact();
          }
        } else {
          _isPreparing = false;
          timer.cancel();
          HapticFeedback.mediumImpact();
          _startStopwatch();
        }
      });
    });
  }

  void _startStopwatch() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _elapsedMilliseconds += 10;
      });
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() {
      _isPaused = true;
      _isRunning = false;
    });
  }

  void _resume() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });
    _startStopwatch();
  }

  void _lap() {
    HapticFeedback.lightImpact();
    setState(() {
      _laps.insert(0, _elapsedMilliseconds);
    });
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _prepareSeconds = widget.workout.prepareSeconds;
      _elapsedMilliseconds = 0;
      _isPreparing = true;
      _isRunning = false;
      _isPaused = false;
      _laps.clear();
    });
  }

  String _formatTime(int milliseconds) {
    final minutes = (milliseconds ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((milliseconds ~/ 1000) % 60).toString().padLeft(2, '0');
    final ms = ((milliseconds % 1000) ~/ 10).toString().padLeft(2, '0');
    return '$minutes:$seconds.$ms';
  }

  String _formatLapTime(int index) {
    if (index == _laps.length - 1) {
      return _formatTime(_laps[index]);
    }
    final diff = _laps[index] - _laps[index + 1];
    return _formatTime(diff);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
        leading: NeumorphicButton(
          onPressed: () {
            _timer?.cancel();
            Navigator.of(context).pop();
          },
          size: 40,
          child: const Icon(Icons.close, color: AppTheme.textPrimary, size: 20),
        ),
        leadingWidth: 56,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              
              // Main display
              _buildDisplay(),
              
              const Spacer(),
              
              // Laps list
              if (_laps.isNotEmpty) _buildLapsList(),
              
              // Controls
              _buildControls(),
              
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisplay() {
    if (_isPreparing && !_isRunning && !_isPaused) {
      // Initial state - show prepare time
      return Column(
        children: [
          const Text(
            'READY',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 18,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${widget.workout.prepareSeconds}',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      );
    }

    if (_isPreparing && _isRunning) {
      // Counting down
      return Column(
        children: [
          const Text(
            'GET READY',
            style: TextStyle(
              color: AppTheme.colorWork,
              fontSize: 18,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$_prepareSeconds',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: AppTheme.colorWork,
            ),
          ),
        ],
      );
    }

    // Stopwatch running
    return Column(
      children: [
        Text(
          _isRunning ? 'RUNNING' : (_isPaused ? 'PAUSED' : 'STOPPED'),
          style: TextStyle(
            color: _isRunning ? AppTheme.colorWork : AppTheme.textSecondary,
            fontSize: 18,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _formatTime(_elapsedMilliseconds),
          style: const TextStyle(
            fontFamily: 'Courier',
            fontSize: 56,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildLapsList() {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(bottom: 24),
      child: NeumorphicContainer(
        padding: const EdgeInsets.all(16),
        isPressed: true,
        child: ListView.builder(
          itemCount: _laps.length,
          itemBuilder: (context, index) {
            final lapNumber = _laps.length - index;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lap $lapNumber',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    _formatLapTime(index),
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Courier',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildControls() {
    // Initial state
    if (!_isRunning && !_isPaused && _isPreparing) {
      return ControlButton(
        icon: Icons.play_arrow_rounded,
        onPressed: _start,
        isPrimary: true,
        size: 80,
        glowColor: AppTheme.colorWork,
      );
    }

    // Preparing
    if (_isPreparing && _isRunning) {
      return ControlButton(
        icon: Icons.stop_rounded,
        onPressed: _reset,
        size: 80,
      );
    }

    // Running
    if (_isRunning) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ControlButton(
            icon: Icons.flag_rounded,
            onPressed: _lap,
            size: 56,
          ),
          const SizedBox(width: 24),
          ControlButton(
            icon: Icons.pause_rounded,
            onPressed: _pause,
            isPrimary: true,
            size: 80,
            glowColor: AppTheme.colorWork,
          ),
          const SizedBox(width: 24),
          ControlButton(
            icon: Icons.stop_rounded,
            onPressed: _reset,
            size: 56,
          ),
        ],
      );
    }

    // Paused
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ControlButton(
          icon: Icons.refresh_rounded,
          onPressed: _reset,
          size: 56,
        ),
        const SizedBox(width: 24),
        ControlButton(
          icon: Icons.play_arrow_rounded,
          onPressed: _resume,
          isPrimary: true,
          size: 80,
          glowColor: AppTheme.colorWork,
        ),
        const SizedBox(width: 24),
        ControlButton(
          icon: Icons.flag_rounded,
          onPressed: _lap,
          size: 56,
        ),
      ],
    );
  }
}
