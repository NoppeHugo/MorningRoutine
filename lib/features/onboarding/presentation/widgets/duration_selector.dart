import 'package:flutter/material.dart';
 
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_atmosphere.dart';
 
class DurationSelector extends StatelessWidget {
  const DurationSelector({
    super.key,
    required this.selectedDuration,
    required this.onDurationSelected,
  });
 
  final int? selectedDuration;
  final ValueChanged<int> onDurationSelected;
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.5,
        children: AppConstants.durationOptions.map((duration) {
          final isSelected = selectedDuration == duration;
          final label = AppConstants.durationLabels[duration] ?? '';
          return _DurationCard(
            duration: duration,
            label: label,
            isSelected: isSelected,
            onTap: () => onDurationSelected(duration),
          );
        }).toList(),
      ),
    );
  }
}
 
class _DurationCard extends StatelessWidget {
  const _DurationCard({
    required this.duration,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
 
  final int duration;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.0 : 0.985,
        duration: const Duration(milliseconds: 200),
        child: AppGlassContainer(
          radius: AppSpacing.radiusMedium,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.sm,
          ),
          color: isSelected ? const Color(0x3BF6F8FF) : const Color(0x24F8FAFF),
          borderColor: isSelected ? const Color(0xA3F2F5FA) : const Color(0x66F2F5FA),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${duration}min',
                style: AppTypography.headingMedium.copyWith(
                  color: const Color(0xFFF3F6FB),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: isSelected
                      ? const Color(0xFFF0F3F9)
                      : const Color(0xD9DDE6F0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
