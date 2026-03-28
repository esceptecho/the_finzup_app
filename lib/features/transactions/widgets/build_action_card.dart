import 'package:flutter/material.dart';
import 'package:the_finzup_app/features/dashboard/ui/app_colors.dart';

class BuildActionCard extends StatelessWidget {
  const BuildActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap,
      child: Container(
        width: 90,
        height: 70,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Column(
          mainAxisAlignment: .spaceAround,
          children: [
            Icon(icon, color: AppColors.iceWhite, size: 18),
            // const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 12,), textAlign: .center,
            ),
          ],
        ),
      ),
    );
  }
}
