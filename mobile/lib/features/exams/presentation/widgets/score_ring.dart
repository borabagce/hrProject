import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';

class ScoreRing extends StatelessWidget {
  const ScoreRing({
    required this.percent,
    required this.correct,
    required this.total,
    super.key,
  });

  final double percent;
  final int correct;
  final int total;

  @override
  Widget build(BuildContext context) {
    final Color scoreColor = AppColors.scoreColor(percent);

    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          PieChart(
            PieChartData(
              startDegreeOffset: -90,
              centerSpaceRadius: 70,
              sectionsSpace: 0,
              sections: <PieChartSectionData>[
                PieChartSectionData(
                  value: percent,
                  color: scoreColor,
                  radius: 16,
                  showTitle: false,
                ),
                PieChartSectionData(
                  value: (100 - percent).clamp(0, 100).toDouble(),
                  color: AppColors.divider,
                  radius: 16,
                  showTitle: false,
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '${percent.round()}%',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: scoreColor),
              ),
              const SizedBox(height: AppDimens.spaceXs),
              Text(
                '$correct / $total',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
