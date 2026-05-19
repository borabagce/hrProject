import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';

class ExamProgressHeader extends StatelessWidget {
  const ExamProgressHeader({
    required this.currentIndex,
    required this.total,
    super.key,
  });

  final int currentIndex;
  final int total;

  @override
  Widget build(BuildContext context) {
    final double progress = total == 0 ? 0 : (currentIndex + 1) / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${AppStrings.questionOf} ${currentIndex + 1} / $total',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              '${(progress * 100).round()}%',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceSm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.radiusPill),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.divider,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }
}
