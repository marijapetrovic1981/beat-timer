import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'neumorphic_container.dart';

/// Modal with single scroll wheel for numbers (1-100)
class NumberPickerModal extends StatefulWidget {
  final String title;
  final int initialValue;
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onConfirm;

  const NumberPickerModal({
    super.key,
    required this.title,
    required this.initialValue,
    this.minValue = 1,
    this.maxValue = 100,
    required this.onConfirm,
  });

  /// Shows the modal and returns the selected value
  static Future<int?> show({
    required BuildContext context,
    required String title,
    required int initialValue,
    int minValue = 1,
    int maxValue = 100,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      builder: (context) => NumberPickerModal(
        title: title,
        initialValue: initialValue,
        minValue: minValue,
        maxValue: maxValue,
        onConfirm: (value) => Navigator.of(context).pop(value),
      ),
    );
  }

  @override
  State<NumberPickerModal> createState() => _NumberPickerModalState();
}

class _NumberPickerModalState extends State<NumberPickerModal> {
  late FixedExtentScrollController _controller;
  late int _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    final initialIndex = widget.initialValue - widget.minValue;
    _controller = FixedExtentScrollController(initialItem: initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.maxValue - widget.minValue + 1;
    
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
            
            // Picker
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Selection highlight
                  NeumorphicContainer(
                    isPressed: true,
                    borderRadius: 12,
                    height: 50,
                    width: 100,
                    child: const SizedBox(),
                  ),
                  // Wheel
                  ListWheelScrollView.useDelegate(
                    controller: _controller,
                    itemExtent: 50,
                    perspective: 0.005,
                    diameterRatio: 1.2,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedValue = widget.minValue + index;
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: itemCount,
                      builder: (context, index) {
                        final value = widget.minValue + index;
                        final isSelected = _selectedValue == value;
                        return Center(
                          child: Text(
                            value.toString(),
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
            
            // Buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    child: NeumorphicButton(
                      onPressed: () => widget.onConfirm(_selectedValue),
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
}
