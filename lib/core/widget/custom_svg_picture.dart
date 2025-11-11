import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSvgPicture extends StatelessWidget {
  const CustomSvgPicture({
    super.key,
    required this.path,
    this.withColorFilter = true,
    this.height,
    this.width,
  });

  const CustomSvgPicture.withoutColor({
    super.key,
    required this.path,
    this.height,
    this.width,
  }) : withColorFilter = false;

  final String path;
  final bool withColorFilter;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      height: height,
      width: width,
      path,
      colorFilter: withColorFilter
          ? ColorFilter.mode(
              Theme.of(context).colorScheme.secondary,
              BlendMode.srcIn,
            )
          : null,
    );
  }
}
