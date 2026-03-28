import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomAnimationDialog extends StatelessWidget {
  final String title;
  final String lottiePath;
  final bool repeatAnimation;
  final List<Widget>? extraContent; // Para agregar botones o más texto

  const CustomAnimationDialog({
    super.key,
    required this.title,
    required this.lottiePath,
    this.repeatAnimation = false,
    this.extraContent,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              width: 120,
              child: Lottie.asset(
                lottiePath,
                fit: BoxFit.contain,
                repeat: repeatAnimation,
              ),
            ),
            // Si hay contenido extra (como botones), lo desplegamos aquí
            if (extraContent != null) ...[
              const SizedBox(height: 15),
              ...extraContent!,
            ],
          ],
        ),
      ),
    );
  }
}

class DialogHelper {
  static void showAnimated(
    BuildContext context, {
    required String title,
    required String lottiePath,
    List<Widget>? actions,
  }) {
    showDialog(
      context: context,
      builder: (context) => CustomAnimationDialog(
        title: title, 
        lottiePath: lottiePath,
        extraContent: actions,
      ),
    );
  }
}

