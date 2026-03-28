import 'package:flutter/material.dart';
import 'package:the_finzup_app/features/dashboard/ui/app_colors.dart';

class SegmentButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isActive;
  const SegmentButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: isActive
            ? BoxDecoration(
                border: .all(color: AppColors.dividerColor),
                color: AppColors.cardBgColor,
                borderRadius: BorderRadius.circular(10),
              )
            : null,
        alignment: .center,
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? AppColors.iceWhite : AppColors.greyText,
            fontWeight: .w600,
          ),
        ),
      ),
    );
  }
}
