import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';

class OptionTile extends StatelessWidget {
  const OptionTile({
    required this.label,
    required this.text,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color borderColor =
        isSelected ? AppColors.primary : AppColors.divider;
    final Color bg = isSelected
        ? AppColors.primary.withOpacity(0.06)
        : AppColors.surface;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        child: Container(
          constraints: const BoxConstraints(minHeight: AppDimens.minTapTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceLg,
            vertical: AppDimens.spaceMd,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radiusLg),
            border: Border.all(color: borderColor, width: isSelected ? 1.6 : 1),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.divider.withOpacity(0.6),
                ),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
