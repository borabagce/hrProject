import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../data/exam_repository.dart';
import '../../domain/exam_question.dart';
import '../../domain/test_session.dart';
import '../../providers/assignments_provider.dart';
import '../../providers/exam_session_notifier.dart';
import '../widgets/exam_progress_header.dart';
import '../widgets/option_tile.dart';

class ExamScreen extends ConsumerStatefulWidget {
  const ExamScreen({required this.sessionId, this.assignmentId, super.key});

  final String sessionId;
  final String? assignmentId;

  @override
  ConsumerState<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends ConsumerState<ExamScreen> {
  DateTime? _questionShownAt;

  void _resetTimer() {
    _questionShownAt = DateTime.now();
  }

  double? _elapsedSec() {
    if (_questionShownAt == null) return null;
    return DateTime.now()
            .difference(_questionShownAt!)
            .inMilliseconds /
        1000;
  }

  Future<bool> _confirmSubmit() async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext c) => AlertDialog(
        title: const Text(AppStrings.confirmSubmit),
        content: const Text(AppStrings.confirmSubmitMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  Future<void> _onNext(ExamSessionState state) async {
    final ExamQuestion q = state.questions[state.currentIndex];
    final int? selected = state.selectedByQuestionId[q.id];
    if (selected == null) return;

    final bool isLast = state.currentIndex == state.questions.length - 1;

    if (isLast && !await _confirmSubmit()) return;

    final ExamSessionNotifier notifier = ref.read(
      examSessionNotifierProvider(widget.sessionId).notifier,
    );
    final AnswerResult? result =
        await notifier.submitCurrent(responseTimeSec: _elapsedSec());
    if (result == null) return;

    if (isLast) {
      if (widget.assignmentId != null) {
        final ExamRepository repo =
            await ref.read(examRepositoryProvider.future);
        await repo.completeAssignment(widget.assignmentId!);
      }
      ref.invalidate(assignmentsProvider);
      if (mounted) {
        context.go('${AppRoutes.examResult}/${widget.sessionId}');
      }
    } else {
      notifier.goTo(state.currentIndex + 1);
      _resetTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ExamSessionState> state =
        ref.watch(examSessionNotifierProvider(widget.sessionId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.tabTests),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object e, _) => EmptyState(
          title: e.toString(),
          icon: Icons.error_outline,
        ),
        data: (ExamSessionState s) {
          _questionShownAt ??= DateTime.now();
          if (s.questions.isEmpty) {
            return const EmptyState(title: AppStrings.somethingWentWrong);
          }
          final ExamQuestion q = s.questions[s.currentIndex];
          final int? selected = s.selectedByQuestionId[q.id];

          return SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(AppDimens.spaceLg),
                  child: ExamProgressHeader(
                    currentIndex: s.currentIndex,
                    total: s.questions.length,
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimens.spaceLg,
                      0,
                      AppDimens.spaceLg,
                      AppDimens.spaceLg,
                    ),
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(AppDimens.spaceLg),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius:
                              BorderRadius.circular(AppDimens.radiusLg),
                        ),
                        child: Text(
                          q.text,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceLg),
                      ...q.options.asMap().entries.map(
                        (MapEntry<int, ExamOption> entry) {
                          final ExamOption o = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppDimens.spaceMd,
                            ),
                            child: OptionTile(
                              label: String.fromCharCode(65 + entry.key),
                              text: o.text,
                              isSelected: selected == o.order,
                              onTap: () => ref
                                  .read(examSessionNotifierProvider(
                                          widget.sessionId)
                                      .notifier)
                                  .select(q.id, o.order),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                _BottomBar(
                  state: s,
                  onNext: () => _onNext(s),
                  onPrevious: () => ref
                      .read(examSessionNotifierProvider(widget.sessionId)
                          .notifier)
                      .goTo(s.currentIndex - 1),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.state,
    required this.onNext,
    required this.onPrevious,
  });

  final ExamSessionState state;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context) {
    final bool isLast =
        state.currentIndex == state.questions.length - 1;
    final ExamQuestion q = state.questions[state.currentIndex];
    final bool hasSelection = state.selectedByQuestionId.containsKey(q.id);

    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          if (state.currentIndex > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: state.isSubmitting ? null : onPrevious,
                child: const Text(AppStrings.previous),
              ),
            ),
          if (state.currentIndex > 0)
            const SizedBox(width: AppDimens.spaceMd),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: (hasSelection && !state.isSubmitting) ? onNext : null,
              child: state.isSubmitting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(isLast ? AppStrings.submit : AppStrings.next),
            ),
          ),
        ],
      ),
    );
  }
}
