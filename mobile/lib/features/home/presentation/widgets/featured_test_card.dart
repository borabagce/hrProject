import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';

class FeaturedTestCard extends StatelessWidget {
  const FeaturedTestCard({
    required this.title,
    required this.onStart,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[Color(0xFFFFFFFF), Color(0xFFF7FAFA)],
      ),
      onTap: onStart,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                if (subtitle != null) ...<Widget>[
                  const SizedBox(height: AppDimens.spaceXs),
                  Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
                ],
                const SizedBox(height: AppDimens.spaceLg),
                ElevatedButton.icon(
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentPurple,
                    minimumSize: const Size(140, 44),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                  label: const Text(AppStrings.startTest),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimens.spaceMd),
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppDimens.radiusLg),
            ),
            child: const Icon(
              Icons.science_outlined,
              size: 48,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
