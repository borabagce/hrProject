import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../../auth/providers/auth_notifier.dart';
import '../../../exams/data/exam_repository.dart';
import '../../../exams/domain/assignment.dart';
import '../../../exams/providers/assignments_provider.dart';
import '../widgets/analytics_tile_row.dart';
import '../widgets/assignment_summary_card.dart';
import '../widgets/featured_test_card.dart';
import '../widgets/home_header.dart';
import '../widgets/profile_strip.dart';
import '../widgets/quick_actions.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _firstName(String full) {
    final List<String> parts = full.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? '' : parts.first;
  }

  Future<void> _startAssignment(
    BuildContext context,
    WidgetRef ref,
    Assignment a,
  ) async {
    final ExamRepository repo =
        await ref.read(examRepositoryProvider.future);
    try {
      final session = await repo.startAssignment(a.id);
      if (context.mounted) {
        context.push(
          '${AppRoutes.exam}/${session.id}?assignmentId=${a.id}',
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState? auth = ref.watch(authNotifierProvider).valueOrNull;
    final String name = switch (auth) {
      AuthAuthenticated(:final user) => _firstName(user.fullName),
      _ => '',
    };
    final String role = switch (auth) {
      AuthAuthenticated(:final user) => user.role.toUpperCase(),
      _ => '',
    };

    final AsyncValue<List<Assignment>> assignments =
        ref.watch(assignmentsProvider());

    return RefreshIndicator(
      onRefresh: () async => ref.refresh(assignmentsProvider().future),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          HomeHeader(userName: name.isEmpty ? '—' : name),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.spaceLg,
              AppDimens.spaceLg,
              AppDimens.spaceLg,
              AppDimens.spaceXxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                QuickActions(
                  onTests: () => context.go(AppRoutes.tests),
                  onProfile: () => context.go(AppRoutes.profile),
                  onAnalytics: () => context.go(AppRoutes.analytics),
                ),
                const SizedBox(height: AppDimens.spaceLg),
                _buildAssignmentSection(context, ref, assignments),
                const SizedBox(height: AppDimens.spaceLg),
                const SectionHeader(
                  title: AppStrings.about,
                  dotColor: AppColors.success,
                ),
                ProfileStrip(
                  fullName: switch (auth) {
                    AuthAuthenticated(:final user) => user.fullName,
                    _ => '—',
                  },
                  subtitle: role,
                  onEdit: () => context.go(AppRoutes.profile),
                  onCalendar: () => context.go(AppRoutes.tests),
                ),
                const SizedBox(height: AppDimens.spaceLg),
                const SectionHeader(
                  title: AppStrings.analyses,
                  dotColor: AppColors.accentOrange,
                ),
                AnalyticsTileRow(
                  onPerformance: () => context.go(AppRoutes.analytics),
                  onStress: () => context.go(AppRoutes.analytics),
                ),
                const SizedBox(height: AppDimens.spaceLg),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => context.go(AppRoutes.analytics),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text(AppStrings.detailedReports),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentPurple,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Assignment>> assignments,
  ) {
    return assignments.when(
      data: (List<Assignment> list) {
        final Assignment? pending = list.firstWhere(
          (Assignment a) => a.status == AssignmentStatus.pending,
          orElse: () => Assignment(
            id: '',
            status: AssignmentStatus.pending,
          ),
        );
        final Iterable<Assignment> inProgress = list.where(
          (Assignment a) => a.status == AssignmentStatus.inProgress,
        );

        if (list.isEmpty) {
          return const EmptyState(
            title: AppStrings.emptyTests,
            icon: Icons.assignment_outlined,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (pending != null && pending.id.isNotEmpty) ...<Widget>[
              FeaturedTestCard(
                title: AppStrings.newTestReady,
                subtitle: pending.testId?.title,
                onStart: () => _startAssignment(context, ref, pending),
              ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05),
              const SizedBox(height: AppDimens.spaceMd),
            ],
            ...inProgress.map(
              (Assignment a) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.spaceMd),
                child: AssignmentSummaryCard(
                  assignment: a,
                  progressPercent: 50,
                  onTap: () => _startAssignment(context, ref, a),
                ),
              ),
            ),
          ],
        );
      },
      loading: () => Column(
        children: const <Widget>[
          ShimmerBox(height: 120),
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
    );
  }
}
