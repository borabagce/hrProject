import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/storage/isar_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/test_session.dart';
import '../../providers/session_result_provider.dart';
import '../widgets/score_ring.dart';

class ExamResultScreen extends ConsumerWidget {
  const ExamResultScreen({required this.sessionId, super.key});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<SessionResult> result =
        ref.watch(sessionResultProvider(sessionId));
    final Map<String, IsarQuestion> questionCache =
        ref.watch(sessionQuestionsForResultProvider(sessionId)).valueOrNull ??
            {};

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.viewReport),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: result.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object e, _) => EmptyState(title: e.toString()),
        data: (SessionResult r) {
          final int correct = r.session.correctCount;
          final int total = r.session.totalQuestions;
          final double percent = r.session.scorePercent.toDouble();
          final String? completedDate = r.session.completedAt == null
              ? null
              : DateFormat('dd MMM yyyy, HH:mm', 'tr_TR')
                  .format(r.session.completedAt!);

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(AppDimens.spaceLg),
              children: <Widget>[
                Center(
                  child: ScoreRing(
                    percent: percent,
                    correct: correct,
                    total: total,
                  ),
                ),
                if (completedDate != null) ...<Widget>[
                  const SizedBox(height: AppDimens.spaceMd),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppDimens.spaceXs),
                      Text(
                        '${AppStrings.completedOn}: $completedDate',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: AppDimens.spaceLg),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _StatTile(
                        label: AppStrings.correctCount,
                        value: '$correct',
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: AppDimens.spaceMd),
                    Expanded(
                      child: _StatTile(
                        label: AppStrings.totalQuestions,
                        value: '$total',
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.spaceLg),
                Text(
                  AppStrings.questionBreakdown,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppDimens.spaceMd),
                ...r.answers.asMap().entries.map(
                      (MapEntry<int, UserAnswer> e) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimens.spaceSm,
                        ),
                        child: _AnswerRow(
                          index: e.key + 1,
                          answer: e.value,
                          question: questionCache[e.value.questionId],
                        ),
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppDimens.spaceXs),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _AnswerRow extends StatelessWidget {
  const _AnswerRow({
    required this.index,
    required this.answer,
    required this.question,
  });

  final int index;
  final UserAnswer answer;
  final IsarQuestion? question;

  void _showDetail(BuildContext context) {
    final String questionText =
        question?.text ?? '${AppStrings.questionOf} $index';
    final String givenAnswerText = _optionText(
      question,
      answer.selectedOptionOrder,
    );

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusLg),
        ),
      ),
      builder: (BuildContext c) => Padding(
        padding: const EdgeInsets.all(AppDimens.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 14,
                  backgroundColor: answer.isCorrect
                      ? AppColors.success.withValues(alpha:0.15)
                      : AppColors.error.withValues(alpha:0.15),
                  child: Icon(
                    answer.isCorrect ? Icons.check : Icons.close,
                    size: 16,
                    color:
                        answer.isCorrect ? AppColors.success : AppColors.error,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSm),
                Text(
                  '${AppStrings.questionOf} $index',
                  style: Theme.of(c).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceMd),
            Text(
              questionText,
              style: Theme.of(c).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimens.spaceMd),
            _DetailRow(
              label: AppStrings.givenAnswer,
              value: givenAnswerText,
              color: answer.isCorrect ? AppColors.success : AppColors.error,
            ),
            const SizedBox(height: AppDimens.spaceLg),
          ],
        ),
      ),
    );
  }

  static String _optionText(IsarQuestion? q, int order) {
    if (q == null) return 'Seçenek $order';
    final int idx = q.optionOrders.indexOf(order);
    if (idx >= 0 && idx < q.optionTexts.length) return q.optionTexts[idx];
    return 'Seçenek $order';
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => _showDetail(context),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceLg,
        vertical: AppDimens.spaceMd,
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 16,
            backgroundColor: answer.isCorrect
                ? AppColors.success.withValues(alpha:0.12)
                : AppColors.error.withValues(alpha:0.12),
            child: Icon(
              answer.isCorrect ? Icons.check : Icons.close,
              size: 18,
              color: answer.isCorrect ? AppColors.success : AppColors.error,
            ),
          ),
          const SizedBox(width: AppDimens.spaceMd),
          Expanded(
            child: Text(
              question?.text ?? '${AppStrings.questionOf} $index',
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppDimens.spaceSm),
          const Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$label: ',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.textSecondary),
        ),
        Expanded(
          child: Text(
            value,
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
