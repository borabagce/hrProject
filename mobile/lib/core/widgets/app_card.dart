import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppDimens.spaceLg),
    this.color,
    this.gradient,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius =
        BorderRadius.circular(AppDimens.radiusLg);
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: gradient == null ? (color ?? AppColors.surface) : null,
          gradient: gradient,
          borderRadius: radius,
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          splashColor: AppColors.primary.withOpacity(0.08),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
