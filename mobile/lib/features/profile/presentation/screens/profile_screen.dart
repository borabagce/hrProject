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

  void _showEditProfile(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) {
    showDialog<void>(
      context: context,
      builder: (_) => _EditProfileDialog(
        currentName: currentName,
        onSave: (String name) =>
            ref.read(authNotifierProvider.notifier).updateFullName(name),
      ),
    );
  }

  void _showChangePassword(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (_) => _ChangePasswordDialog(
        onSave: ({
          required String currentPassword,
          required String newPassword,
        }) =>
            ref.read(authNotifierProvider.notifier).changePassword(
                  currentPassword: currentPassword,
                  newPassword: newPassword,
                ),
      ),
    );
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
          ProfileSettingsSection(
            onEditProfile: () =>
                _showEditProfile(context, ref, user?.fullName ?? ''),
            onChangePassword: () => _showChangePassword(context, ref),
          ),
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

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog({
    required this.currentName,
    required this.onSave,
  });

  final String currentName;
  final Future<void> Function(String name) onSave;

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  late final TextEditingController _ctrl =
      TextEditingController(text: widget.currentName);
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final String name = _ctrl.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.onSave(name);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.editProfileTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _ctrl,
            decoration: InputDecoration(
              labelText: AppStrings.fullNameLabel,
              errorText: _error,
            ),
            textCapitalization: TextCapitalization.words,
            enabled: !_loading,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(AppStrings.save),
        ),
      ],
    );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog({required this.onSave});

  final Future<void> Function({
    required String currentPassword,
    required String newPassword,
  }) onSave;

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final TextEditingController _currentCtrl = TextEditingController();
  final TextEditingController _newCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_newCtrl.text != _confirmCtrl.text) {
      setState(() => _error = AppStrings.passwordsNotMatch);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.onSave(
        currentPassword: _currentCtrl.text,
        newPassword: _newCtrl.text,
      );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.passwordChanged)),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.changePasswordTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _currentCtrl,
            decoration: const InputDecoration(
              labelText: AppStrings.currentPasswordLabel,
            ),
            obscureText: true,
            enabled: !_loading,
          ),
          const SizedBox(height: AppDimens.spaceMd),
          TextField(
            controller: _newCtrl,
            decoration: const InputDecoration(
              labelText: AppStrings.newPasswordLabel,
            ),
            obscureText: true,
            enabled: !_loading,
          ),
          const SizedBox(height: AppDimens.spaceMd),
          TextField(
            controller: _confirmCtrl,
            decoration: InputDecoration(
              labelText: AppStrings.confirmPasswordLabel,
              errorText: _error,
            ),
            obscureText: true,
            enabled: !_loading,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(AppStrings.save),
        ),
      ],
    );
  }
}
