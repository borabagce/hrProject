import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';

class TestsSearchBar extends StatelessWidget {
  const TestsSearchBar({
    required this.onSearchChanged,
    super.key,
  });

  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: AppStrings.search,
              prefixIcon: const Icon(Icons.search_rounded),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceLg,
                vertical: AppDimens.spaceMd,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.surface,
            ),
          ),
        ),
        const SizedBox(width: AppDimens.spaceSm),
        Material(
          color: AppColors.primary,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.all(AppDimens.spaceMd),
              child: Icon(Icons.search, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
