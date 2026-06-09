import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../domain/analytics.dart';
import '../../providers/analytics_provider.dart';
import '../widgets/category_breakdown_list.dart';
import '../widgets/trend_chart.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<MyAnalytics> data = ref.watch(myAnalyticsProvider);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async => ref.refresh(myAnalyticsProvider.future),
        child: ListView(
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          children: <Widget>[
            Text(
              AppStrings.analyses,
              style: Theme.of(context).textTheme.displaySmall ??
                  Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: AppDimens.spaceLg),
            data.when(
              loading: () => const Column(
                children: <Widget>[
                  ShimmerBox(height: 220),
                  SizedBox(height: AppDimens.spaceMd),
                  ShimmerBox(height: 120),
                  SizedBox(height: AppDimens.spaceMd),
                  ShimmerBox(height: 120),
                ],
              ),
              error: (Object e, _) => EmptyState(
                title: e.toString(),
                icon: Icons.error_outline,
                action: TextButton(
                  onPressed: () => ref.refresh(myAnalyticsProvider),
                  child: const Text(AppStrings.retry),
                ),
              ),
              data: (MyAnalytics a) => _Content(analytics: a),
            ),
          ],
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.analytics});

  final MyAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SectionHeader(
          title: AppStrings.performanceGraph,
          dotColor: AppColors.accentBlue,
        ),
        AppCard(child: TrendChart(points: analytics.weeklyTrend)),
        const SizedBox(height: AppDimens.spaceLg),
        const SectionHeader(
          title: 'Kategori Performansı',
          dotColor: AppColors.accentOrange,
        ),
        AppCard(
          child: CategoryBreakdownList(items: analytics.wrongByCategory),
        ),
        const SizedBox(height: AppDimens.spaceLg),
        const SectionHeader(
          title: 'Geçmiş Testler',
          dotColor: AppColors.success,
        ),
        if (analytics.sessionHistory.isEmpty)
          const EmptyState(
            title: AppStrings.emptyResults,
            icon: Icons.history_rounded,
          )
        else
          ...analytics.sessionHistory.map(
            (SessionHistoryItem s) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.spaceMd),
              child: _HistoryRow(item: s),
            ),
          ),
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.item});

  final SessionHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final String date = item.completedAt == null
        ? '—'
        : DateFormat('dd MMM yyyy', 'tr_TR').format(item.completedAt!);
    return AppCard(
      onTap: () =>
          context.push('${AppRoutes.examResult}/${item.id}'),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.scoreColor(item.scorePercent.toDouble())
                  .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            ),
            child: Text(
              '${item.scorePercent}%',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.scoreColor(item.scorePercent.toDouble()),
                  ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.testTitle?.isNotEmpty == true
                      ? item.testTitle!
                      : 'Hafta ${item.weekNumber} / ${item.year}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(date, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Text(
            '${item.correctCount}/${item.totalQuestions}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
