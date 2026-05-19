import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../auth/domain/auth_user.dart';
import '../../../auth/providers/auth_notifier.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_settings_section.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext c) => AlertDialog(
        title: const Text(AppStrings.logout),
        content: const Text(AppStrings.logoutConfirm),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(c, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text(AppStrings.logout),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(authNotifierProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState? state = ref.watch(authNotifierProvider).valueOrNull;
    final AuthUser? user = switch (state) {
      AuthAuthenticated(:final user) => user,
      _ => null,
    };

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppDimens.spaceLg),
        children: <Widget>[
          ProfileHeader(user: user),
          const SizedBox(height: AppDimens.spaceLg),
          AppCard(
            child: Column(
              children: <Widget>[
                _Row(
                  icon: Icons.mail_outline_rounded,
                  label: AppStrings.emailLabel,
                  value: user?.email ?? '—',
                ),
                const Divider(height: AppDimens.spaceXl),
                _Row(
                  icon: Icons.badge_outlined,
                  label: 'Rol',
                  value: user?.role.toUpperCase() ?? '—',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          const ProfileSettingsSection(),
          const SizedBox(height: AppDimens.spaceXl),
          OutlinedButton.icon(
            onPressed: () => _confirmLogout(context, ref),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
            ),
            icon: const Icon(Icons.logout_rounded),
            label: const Text(AppStrings.logout),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, color: AppColors.textSecondary, size: 22),
        const SizedBox(width: AppDimens.spaceMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
        ),
      ],
    );
  }
}
