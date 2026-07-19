import 'package:flutter/material.dart';
import '../../utils/app_size.dart';

class IconButtonWidget extends StatelessWidget {
  final double? padding;
  final VoidCallback? onTap;
  final Widget child;

  final Color color;
  const IconButtonWidget({
    super.key,
    this.padding,
    this.onTap,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final double defaultPadding =AppSize.size.width * 0.02;
    return GestureDetector(
      onTap:onTap ,
      child: Container(
        padding: EdgeInsets.all(padding ?? defaultPadding) ,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }
}