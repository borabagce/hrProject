import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    this.icon = Icons.inbox_outlined,
    this.action,
    super.key,
  });

  final String title;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 56, color: AppColors.textSecondary),
            const SizedBox(height: AppDimens.spaceMd),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            if (action != null) ...<Widget>[
              const SizedBox(height: AppDimens.spaceLg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
