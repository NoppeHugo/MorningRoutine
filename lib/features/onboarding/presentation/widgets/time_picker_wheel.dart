import 'package:flutter/material.dart';
 
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
 
class TimePickerWheel extends StatefulWidget {
  const TimePickerWheel({
    super.key,
    required this.initialTime,
    required this.onTimeChanged,
  });
 
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;
 
  @override
  State<TimePickerWheel> createState() => _TimePickerWheelState();
}
 
class _TimePickerWheelState extends State<TimePickerWheel> {
  late final FixedExtentScrollController _hourController;
  late final FixedExtentScrollController _minuteController;
  late int _selectedHour;
  late int _selectedMinute;
 
  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialTime.hour;
    _selectedMinute = widget.initialTime.minute ~/ 5;
    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController =
        FixedExtentScrollController(initialItem: _selectedMinute);
  }
 
  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }
 
  void _onChanged() {
    widget.onTimeChanged(
      TimeOfDay(hour: _selectedHour, minute: _selectedMinute * 5),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hours
            SizedBox(
              width: 80,
              child: ListWheelScrollView.useDelegate(
                controller: _hourController,
                itemExtent: 50,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  _selectedHour = index;
                  _onChanged();
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: 24,
                  builder: (context, index) {
                    final isSelected = index == _selectedHour;
                    return Center(
                      child: Text(
                        index.toString().padLeft(2, '0'),
                        style: isSelected
                            ? AppTypography.headingLarge
                            : AppTypography.headingMedium.copyWith(
                                color: AppColors.textTertiary,
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Separator
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Text(
                ':',
                style: AppTypography.headingLarge,
              ),
            ),
            // Minutes (by 5)
            SizedBox(
              width: 80,
              child: ListWheelScrollView.useDelegate(
                controller: _minuteController,
                itemExtent: 50,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  _selectedMinute = index;
                  _onChanged();
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: 12,
                  builder: (context, index) {
                    final minuteValue = index * 5;
                    final isSelected = index == _selectedMinute;
                    return Center(
                      child: Text(
                        minuteValue.toString().padLeft(2, '0'),
                        style: isSelected
                            ? AppTypography.headingLarge
                            : AppTypography.headingMedium.copyWith(
                                color: AppColors.textTertiary,
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
