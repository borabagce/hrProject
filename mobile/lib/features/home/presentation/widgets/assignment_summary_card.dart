import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../../exams/domain/assignment.dart';

class AssignmentSummaryCard extends StatelessWidget {
  const AssignmentSummaryCard({
    required this.assignment,
    required this.progressPercent,
    required this.onTap,
    super.key,
  });

  final Assignment assignment;
  final double progressPercent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isInProgress =
        assignment.status == AssignmentStatus.inProgress;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            assignment.testId?.title ?? '—',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppDimens.spaceSm),
          if (isInProgress)
            Row(
              children: <Widget>[
                Expanded(child: AppProgressBar(percent: progressPercent)),
                const SizedBox(width: AppDimens.spaceSm),
                Text(
                  '${progressPercent.round()}%',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceSm,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimens.radiusPill),
              ),
              child: Text(
                AppStrings.pending,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          const SizedBox(height: AppDimens.spaceMd),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                backgroundColor: AppColors.accentOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceLg,
                  vertical: AppDimens.spaceSm,
                ),
              ),
              child: Text(
                isInProgress ? AppStrings.continueTest : AppStrings.startTest,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
