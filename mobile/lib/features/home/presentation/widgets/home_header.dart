import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({required this.userName, this.onNotificationsTap, super.key});

  final String userName;
  final VoidCallback? onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceXl,
        AppDimens.spaceXl,
        AppDimens.spaceXl,
        AppDimens.spaceXxl,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFFFAFDFE), Color(0xFFE7F2F2)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDimens.radiusXl),
          bottomRight: Radius.circular(AppDimens.radiusXl),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: AppDimens.spaceMd),
                Text(
                  '${AppStrings.homeGreeting}, $userName!',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: AppDimens.spaceXs),
                Text(
                  AppStrings.appTagline,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            iconSize: 28,
            onPressed: onNotificationsTap,
            icon: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.textPrimary,
                ),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
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
}
