import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'neumorphic_container.dart';

/// Modal with two scroll wheels for minutes (0-60) and seconds (0-59)
class TimePickerModal extends StatefulWidget {
  final String title;
  final int initialSeconds;
  final ValueChanged<int> onConfirm;

  const TimePickerModal({
    super.key,
    required this.title,
    required this.initialSeconds,
    required this.onConfirm,
  });

  /// Shows the modal and returns the selected value in seconds
  static Future<int?> show({
    required BuildContext context,
    required String title,
    required int initialSeconds,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      builder: (context) => TimePickerModal(
        title: title,
        initialSeconds: initialSeconds,
        onConfirm: (value) => Navigator.of(context).pop(value),
      ),
    );
  }

  @override
  State<TimePickerModal> createState() => _TimePickerModalState();
}

class _TimePickerModalState extends State<TimePickerModal> {
  late FixedExtentScrollController _minutesController;
  late FixedExtentScrollController _secondsController;
  late int _minutes;
  late int _seconds;

  @override
  void initState() {
    super.initState();
    _minutes = widget.initialSeconds ~/ 60;
    _seconds = widget.initialSeconds % 60;
    _minutesController = FixedExtentScrollController(initialItem: _minutes);
    _secondsController = FixedExtentScrollController(initialItem: _seconds);
  }

  @override
  void dispose() {
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.shadowLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            
            // Pickers
            SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Minutes
                  _buildWheel(
                    controller: _minutesController,
                    itemCount: 61, // 0-60
                    onChanged: (value) => setState(() => _minutes = value),
                    label: 'min',
                  ),
                  
                  // Separator
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      ':',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  
                  // Seconds
                  _buildWheel(
                    controller: _secondsController,
                    itemCount: 60, // 0-59
                    onChanged: (value) => setState(() => _seconds = value),
                    label: 'sec',
                  ),
                ],
              ),
            ),
            
            // Buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    child: NeumorphicButton(
                      onPressed: () {
                        final totalSeconds = (_minutes * 60) + _seconds;
                        widget.onConfirm(totalSeconds);
                      },
                      size: 56,
                      isCircle: false,
                      glowColor: AppTheme.colorWork,
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          color: AppTheme.colorWork,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Back button
                  SizedBox(
                    width: double.infinity,
                    child: NeumorphicButton(
                      onPressed: () => Navigator.of(context).pop(),
                      size: 56,
                      isCircle: false,
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required ValueChanged<int> onChanged,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 18,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          height: 160,
          child: Stack(
            children: [
              // Selection highlight
              Center(
                child: NeumorphicContainer(
                  isPressed: true,
                  borderRadius: 12,
                  height: 50,
                  width: 80,
                  child: const SizedBox(),
                ),
              ),
              // Wheel
              ListWheelScrollView.useDelegate(
                controller: controller,
                itemExtent: 50,
                perspective: 0.005,
                diameterRatio: 1.2,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: onChanged,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: itemCount,
                  builder: (context, index) {
                    final isSelected = controller.selectedItem == index;
                    return Center(
                      child: Text(
                        index.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontSize: isSelected ? 28 : 20,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected 
                              ? AppTheme.textPrimary 
                              : AppTheme.textSecondary.withValues(alpha: 0.5),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
