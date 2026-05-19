import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import 'connectivity_provider.dart';

class ConnectivityBanner extends ConsumerWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<bool> online = ref.watch(connectivityStatusProvider);
    final bool isOnline = online.maybeWhen(
      data: (bool v) => v,
      orElse: () => true,
    );
    if (isOnline) return const SizedBox.shrink();

    return Material(
      color: AppColors.warning,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceLg,
          vertical: AppDimens.spaceSm,
        ),
        child: Row(
          children: <Widget>[
            const Icon(Icons.cloud_off, color: Colors.white, size: 18),
            const SizedBox(width: AppDimens.spaceSm),
            Expanded(
              child: Text(
                AppStrings.offlineBanner,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
