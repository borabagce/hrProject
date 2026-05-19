import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({
    required this.onTests,
    required this.onProfile,
    required this.onAnalytics,
    super.key,
  });

  final VoidCallback onTests;
  final VoidCallback onProfile;
  final VoidCallback onAnalytics;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _PillAction(
            icon: Icons.task_alt_rounded,
            label: AppStrings.myTests,
            color: AppColors.success,
            onTap: onTests,
          ),
        ),
        const SizedBox(width: AppDimens.spaceMd),
        Expanded(
          child: _PillAction(
            icon: Icons.person_outline_rounded,
            label: AppStrings.about,
            color: AppColors.accentPurple,
            onTap: onProfile,
          ),
        ),
        const SizedBox(width: AppDimens.spaceMd),
        Expanded(
          child: _PillAction(
            icon: Icons.bar_chart_rounded,
            label: AppStrings.analyses,
            color: AppColors.accentOrange,
            onTap: onAnalytics,
          ),
        ),
      ],
    );
  }
}

class _PillAction extends StatelessWidget {
  const _PillAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceSm,
            vertical: AppDimens.spaceMd,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: AppDimens.spaceXs),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
