import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/app_strings.dart';
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
                        child: _AnswerRow(index: e.key + 1, answer: e.value),
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
  const _AnswerRow({required this.index, required this.answer});

  final int index;
  final UserAnswer answer;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceLg,
        vertical: AppDimens.spaceMd,
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 16,
            backgroundColor: answer.isCorrect
                ? AppColors.success.withOpacity(0.12)
                : AppColors.error.withOpacity(0.12),
            child: Icon(
              answer.isCorrect ? Icons.check : Icons.close,
              size: 18,
              color: answer.isCorrect ? AppColors.success : AppColors.error,
            ),
          ),
          const SizedBox(width: AppDimens.spaceMd),
          Expanded(
            child: Text(
              '${AppStrings.questionOf} $index',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Text(
            answer.isCorrect
                ? AppStrings.correctAnswer
                : AppStrings.wrongAnswer,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: answer.isCorrect
                      ? AppColors.success
                      : AppColors.error,
                ),
          ),
        ],
      ),
    );
  }
}
