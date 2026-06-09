import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';

class AnalyticsTileRow extends StatelessWidget {
  const AnalyticsTileRow({
    required this.onPerformance,
    required this.onReports,
    super.key,
  });

  final VoidCallback onPerformance;
  final VoidCallback onReports;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _Tile(
            title: AppStrings.performanceGraph,
            icon: Icons.show_chart_rounded,
            gradient: const LinearGradient(
              colors: <Color>[Color(0xFF7AB8E9), Color(0xFFB6A8E0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onTap: onPerformance,
          ),
        ),
        const SizedBox(width: AppDimens.spaceMd),
        Expanded(
          child: _Tile(
            title: AppStrings.detailedReports,
            icon: Icons.bar_chart_rounded,
            gradient: const LinearGradient(
              colors: <Color>[Color(0xFF4DB6AC), Color(0xFF2A9D8F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onTap: onReports,
          ),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      gradient: gradient,
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      onTap: onTap,
      child: SizedBox(
        height: 110,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(icon, size: 48, color: Colors.white.withValues(alpha: 0.85)),
            ),
          ],
        ),
      ),
    );
  }
}
