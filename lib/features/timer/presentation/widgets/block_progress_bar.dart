import 'package:flutter/material.dart';
 
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
 
class BlockProgressBar extends StatelessWidget {
  const BlockProgressBar({
    super.key,
    required this.totalBlocks,
    required this.currentBlockIndex,
    required this.completedBlockResults,
  });
 
  final int totalBlocks;
  final int currentBlockIndex;
  final List<bool> completedBlockResults;
 
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalBlocks, (index) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
            height: 4,
            decoration: BoxDecoration(
              color: _getColor(index),
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
          ),
        );
      }),
    );
  }
 
  Color _getColor(int index) {
    if (index < completedBlockResults.length) {
      return completedBlockResults[index]
          ? AppColors.blockCompleted
          : AppColors.blockSkipped;
    }
    if (index == currentBlockIndex) {
      return AppColors.blockCurrent;
    }
    return AppColors.blockPending;
  }
}
