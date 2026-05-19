import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_dimens.dart';

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    this.height = 80,
    this.width = double.infinity,
    this.radius = AppDimens.radiusLg,
    super.key,
  });

  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
