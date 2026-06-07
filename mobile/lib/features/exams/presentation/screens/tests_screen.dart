import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../data/exam_repository.dart';
import '../../domain/assignment.dart';
import '../../providers/assignments_provider.dart';
import '../widgets/assignment_card.dart';
import '../widgets/tests_search_bar.dart';

class TestsScreen extends ConsumerStatefulWidget {
  const TestsScreen({super.key});

  @override
  ConsumerState<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends ConsumerState<TestsScreen>
    with WidgetsBindingObserver {
  String _search = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(assignmentsProvider);
    }
  }

  bool _matches(Assignment a) {
    if (_search.isEmpty) return true;
    final String title = (a.testId?.title ?? '').toLowerCase();
    return title.contains(_search.toLowerCase());
  }

  Future<void> _open(Assignment a) async {
    if (a.status == AssignmentStatus.completed) {
      if (a.sessionId != null) {
        context.push('${AppRoutes.examResult}/${a.sessionId}');
      }
      return;
    }
    final ExamRepository repo =
        await ref.read(examRepositoryProvider.future);
    try {
      final session = await repo.startAssignment(a.id);
      ref.invalidate(assignmentsProvider);
      if (mounted) {
        context.push(
          '${AppRoutes.exam}/${session.id}?assignmentId=${a.id}',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Assignment>> assignments =
        ref.watch(assignmentsProvider());

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async => ref.refresh(assignmentsProvider().future),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.spaceLg,
            AppDimens.spaceLg,
            AppDimens.spaceLg,
            AppDimens.spaceXxl,
          ),
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 22),
                ),
                const SizedBox(width: AppDimens.spaceMd),
                Text(
                  AppStrings.myTests,
                  style: Theme.of(context).textTheme.displaySmall ??
                      Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceLg),
            TestsSearchBar(
              onSearchChanged: (String v) => setState(() => _search = v),
            ),
            const SizedBox(height: AppDimens.spaceLg),
            assignments.when(
              data: (List<Assignment> list) =>
                  _buildSections(list.where(_matches).toList()),
              loading: () => Column(
                children: const <Widget>[
                  ShimmerBox(height: 96),
                  SizedBox(height: AppDimens.spaceMd),
                  ShimmerBox(height: 96),
                  SizedBox(height: AppDimens.spaceMd),
                  ShimmerBox(height: 96),
                ],
              ),
              error: (Object e, _) => EmptyState(
                title: e.toString(),
                icon: Icons.error_outline,
                action: TextButton(
                  onPressed: () => ref.refresh(assignmentsProvider()),
                  child: const Text(AppStrings.retry),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSections(List<Assignment> list) {
    if (list.isEmpty) {
      return const EmptyState(
        title: AppStrings.emptyTests,
        icon: Icons.assignment_outlined,
      );
    }
    final List<Assignment> inProgress = list
        .where((Assignment a) => a.status == AssignmentStatus.inProgress)
        .toList();
    final List<Assignment> pending = list
        .where((Assignment a) => a.status == AssignmentStatus.pending)
        .toList();
    final List<Assignment> completed = list
        .where((Assignment a) => a.status == AssignmentStatus.completed)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (inProgress.isNotEmpty) ...<Widget>[
          const SectionHeader(
            title: AppStrings.inProgress,
            dotColor: AppColors.warning,
          ),
          ...inProgress.map(
            (Assignment a) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.spaceMd),
              child: AssignmentCard(
                assignment: a,
                progressPercent: 50,
                onTap: () => _open(a),
              ),
            ),
          ),
        ],
        if (pending.isNotEmpty) ...<Widget>[
          const SectionHeader(
            title: AppStrings.pending,
            dotColor: AppColors.primary,
          ),
          ...pending.map(
            (Assignment a) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.spaceMd),
              child: AssignmentCard(assignment: a, onTap: () => _open(a)),
            ),
          ),
        ],
        if (completed.isNotEmpty) ...<Widget>[
          const SectionHeader(
            title: AppStrings.completed,
            dotColor: AppColors.success,
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              crossAxisSpacing: AppDimens.spaceMd,
              mainAxisSpacing: AppDimens.spaceMd,
              mainAxisExtent: 180,
            ),
            itemCount: completed.length,
            itemBuilder: (BuildContext c, int i) => _CompletedTile(
              assignment: completed[i],
              onTap: () => _open(completed[i]),
            ),
          ),
        ],
      ],
    );
  }
}

class _CompletedTile extends StatelessWidget {
  const _CompletedTile({required this.assignment, required this.onTap});

  final Assignment assignment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: <Color>[Color(0xFFFFCD8C), Color(0xFFF59F40)],
                    ),
                    borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.spaceMd),
                    child: Text(
                      assignment.testId?.title ?? '—',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                              ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.spaceSm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      'Tamamlandı',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  TextButton(
                    onPressed: onTap,
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.accentPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimens.radiusPill),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spaceMd,
                        vertical: 4,
                      ),
                    ),
                    child: const Text(AppStrings.viewReport),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
