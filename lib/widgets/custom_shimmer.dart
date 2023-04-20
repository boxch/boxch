import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CustomShimmer extends StatelessWidget {
  final Widget child;
  final double? radius;
  CustomShimmer({required this.child, this.radius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius != null ? BorderRadius.circular(radius!) : BorderRadius.circular(0),
      child: Shimmer(
          duration: Duration(milliseconds: 500),
          interval: Duration(milliseconds: 500),
          color: Colors.grey,
          colorOpacity: 0.1,
          enabled: true,
          direction: ShimmerDirection.fromLTRB(),
          child: child),
    );
  }
}
