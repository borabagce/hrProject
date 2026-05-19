import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    required this.percent,
    this.height = 8,
    this.background = AppColors.divider,
    super.key,
  });

  final double percent;
  final double height;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final double clamped = percent.clamp(0, 100).toDouble();
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      child: Stack(
        children: <Widget>[
          Container(height: height, color: background),
          FractionallySizedBox(
            widthFactor: clamped / 100,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: AppColors.scoreColor(clamped),
                borderRadius: BorderRadius.circular(AppDimens.radiusPill),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
