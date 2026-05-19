import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.dotColor = AppColors.accentOrange,
    this.trailing,
    super.key,
  });

  final String title;
  final Color dotColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
      child: Row(
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(width: AppDimens.spaceSm),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppDimens.spaceMd),
          const Expanded(child: Divider()),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
