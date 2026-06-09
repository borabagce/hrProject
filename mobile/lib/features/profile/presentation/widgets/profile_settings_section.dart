import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';

class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({
    required this.onEditProfile,
    required this.onChangePassword,
    super.key,
  });

  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          _Tile(
            icon: Icons.edit_outlined,
            label: 'Profilimi Düzenle',
            onTap: onEditProfile,
          ),
          const Divider(height: 0),
          _Tile(
            icon: Icons.lock_outline_rounded,
            label: 'Şifre Değiştir',
            onTap: onChangePassword,
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label, style: Theme.of(context).textTheme.titleSmall),
      trailing: const Icon(Icons.chevron_right_rounded),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceLg,
        vertical: AppDimens.spaceXs,
      ),
    );
  }
}
