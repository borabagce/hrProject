import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../domain/assignment.dart';

class AssignmentCard extends StatelessWidget {
  const AssignmentCard({
    required this.assignment,
    required this.onTap,
    this.progressPercent,
    super.key,
  });

  final Assignment assignment;
  final VoidCallback onTap;
  final double? progressPercent;

  @override
  Widget build(BuildContext context) {
    final AssignmentStatus status = assignment.status;
    final String title = assignment.testId?.title ?? '—';
    final String subtitle = status == AssignmentStatus.completed
        ? _completionLine(assignment)
        : (assignment.dueDate != null
            ? 'Son tarih: ${DateFormat('dd/MM/yyyy').format(assignment.dueDate!)}'
            : '');

    return AppCard(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          _StatusGlyph(status: status),
          const SizedBox(width: AppDimens.spaceLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                if (subtitle.isNotEmpty) ...<Widget>[
                  const SizedBox(height: AppDimens.spaceXs),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
                if (status == AssignmentStatus.inProgress &&
                    progressPercent != null) ...<Widget>[
                  const SizedBox(height: AppDimens.spaceSm),
                  AppProgressBar(percent: progressPercent!),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppDimens.spaceMd),
          _ActionButton(status: status, onTap: onTap),
        ],
      ),
    );
  }

  String _completionLine(Assignment a) {
    if (a.completedAt == null) return AppStrings.completed;
    return 'Tamamlanma: ${DateFormat('dd/MM/yyyy').format(a.completedAt!)}';
  }
}

class _StatusGlyph extends StatelessWidget {
  const _StatusGlyph({required this.status});

  final AssignmentStatus status;

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final IconData icon;
    switch (status) {
      case AssignmentStatus.completed:
        bg = AppColors.success;
        icon = Icons.check_circle_rounded;
      case AssignmentStatus.inProgress:
        bg = AppColors.warning;
        icon = Icons.timelapse_rounded;
      case AssignmentStatus.pending:
        bg = AppColors.primary;
        icon = Icons.play_arrow_rounded;
      case AssignmentStatus.expired:
        bg = AppColors.error;
        icon = Icons.event_busy_rounded;
    }
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bg.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      ),
      child: Icon(icon, color: bg, size: 24),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.status, required this.onTap});

  final AssignmentStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    late final String label;
    late final Color bg;
    switch (status) {
      case AssignmentStatus.completed:
        label = AppStrings.viewReport;
        bg = AppColors.accentPurple;
      case AssignmentStatus.inProgress:
        label = AppStrings.continueTest;
        bg = AppColors.accentOrange;
      case AssignmentStatus.pending:
        label = AppStrings.startTest;
        bg = AppColors.primary;
      case AssignmentStatus.expired:
        label = AppStrings.completed;
        bg = AppColors.divider;
    }
    return TextButton(
      onPressed: status == AssignmentStatus.expired ? null : onTap,
      style: TextButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMd,
          vertical: AppDimens.spaceSm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusPill),
        ),
      ),
      child: Text(label),
    );
  }
}
