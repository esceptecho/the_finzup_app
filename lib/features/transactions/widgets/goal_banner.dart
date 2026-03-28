// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class GoalBanner extends StatelessWidget {
  final IconData? icon;
  final String text;
  final String? imagePath;
  final Color color;

  const GoalBanner({
    super.key,
    this.icon,
    required this.text,
    this.imagePath,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Reduje el margen horizontal para que se vea mejor en el carrusel
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        // Agregamos una ligera sombra para que resalte
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 15, child: Icon(icon, color: Colors.white, size: 32)),
          const SizedBox(width: 12),
          Expanded(
            flex: 50,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 35,
            child: imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      imagePath!,
                      fit: BoxFit.cover,
                      height: 80,
                    ),
                  )
                : const Icon(Icons.broken_image_outlined, color: Colors.redAccent,),
          ),
          // SizedBox(
          //   height: 300,
          //   child: SingleChildScrollView(
          //     physics: const NeverScrollableScrollPhysics(),
          //     child: Column(
          //       children: [
          //         GoalBanner(
          //           icon: Icons.mood_bad,
          //           color: Colors.transparent,
          //           text: 'texto de prueba',
          //         ),
          //         GoalBanner(
          //           icon: Icons.dark_mode_rounded,
          //           color: Colors.transparent,
          //           text: 'texto de prueba',
          //         ),
          //         GoalBanner(
          //           icon: Icons.graphic_eq,
          //           color: Colors.transparent,
          //           text: 'texto de prueba',
          //         ),
          //         GoalBanner(
          //           icon: Icons.wifi_calling_3_outlined,
          //           color: Colors.transparent,
          //           text: 'texto de prueba',
          //         ),
          //         GoalBanner(
          //           icon: Icons.mood_bad,
          //           color: Colors.transparent,
          //           text: 'texto de prueba',
          //         ),
          //         GoalBanner(
          //           icon: Icons.monitor_outlined,
          //           color: Colors.transparent,
          //           text: 'texto de prueba',
          //         ),
          //         GoalBanner(
          //           icon: Icons.manage_history,
          //           color: Colors.transparent,
          //           text: 'texto de prueba',
          //         ),
          //         GoalBanner(
          //           icon: Icons.chat_rounded,
          //           color: Colors.transparent,
          //           text: 'texto de prueba',
          //         ),
          //         SizedBox(height: 20),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
