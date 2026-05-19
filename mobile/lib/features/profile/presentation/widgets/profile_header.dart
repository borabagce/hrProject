import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../auth/domain/auth_user.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.user, super.key});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      gradient: const LinearGradient(
        colors: <Color>[Color(0xFF2A9D8F), Color(0xFF40C4B5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      padding: const EdgeInsets.all(AppDimens.spaceXl),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 34,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              _initials(user?.fullName ?? '—'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user?.fullName ?? '—',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: AppDimens.spaceXs),
                Text(
                  user?.email ?? '—',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.85),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final String first = parts.first[0];
    final String last = parts.length > 1 ? parts.last[0] : '';
    return '$first$last'.toUpperCase();
  }
}
