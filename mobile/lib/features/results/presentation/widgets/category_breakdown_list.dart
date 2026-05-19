import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../domain/analytics.dart';

class CategoryBreakdownList extends StatelessWidget {
  const CategoryBreakdownList({required this.items, super.key});

  final List<CategoryBreakdown> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text(
        'Henüz veri yok',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    return Column(
      children: items
          .map(
            (CategoryBreakdown c) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          c.categoryName,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      Text(
                        '${(100 - c.errorRate).round()}%',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.scoreColor(100 - c.errorRate),
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.spaceXs),
                  AppProgressBar(percent: 100 - c.errorRate),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
