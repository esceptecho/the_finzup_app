import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NewCustomAnimationDialog extends StatefulWidget {
  final String title;
  final String lottiePath;
  final Duration duration; // <--- Nueva propiedad
  final List<Widget>? extraContent;

  const NewCustomAnimationDialog({
    super.key,
    required this.title,
    required this.lottiePath,
    this.duration = const Duration(seconds: 2), // Duración por defecto
    this.extraContent,
  });

  @override
  State<NewCustomAnimationDialog> createState() => _NewCustomAnimationDialogState();
}

class _NewCustomAnimationDialogState extends State<NewCustomAnimationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Inicializamos el controlador con la duración que viene del widget padre
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward(); // Iniciamos la animación de inmediato
  }

  @override
  void dispose() {
    _controller.dispose(); // IMPORTANTE: Liberar memoria
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: Lottie.asset(
                widget.lottiePath,
                controller: _controller, // <--- Vinculamos el controlador
                onLoaded: (composition) {
                  // Esto asegura que el controlador sepa la duración real si no se la pasas
                  _controller.duration = widget.duration;
                },
              ),
            ),
            if (widget.extraContent != null) ...[
              const SizedBox(height: 15),
              ...widget.extraContent!,
            ],
          ],
        ),
      ),
    );
  }
}

class CustomDialogHelper {
  static void showAnimated(
    BuildContext context, {
    required String title,
    required String lottiePath,
    Duration? duration = const Duration(seconds: 2), 
    List<Widget>? extraContent,
  }) {
    showDialog(
      context: context,
      builder: (context) => NewCustomAnimationDialog(
        title: title, 
        lottiePath: lottiePath,
        extraContent: extraContent,
      ),
    );
  }
}