import 'package:flutter/material.dart';
import 'dart:math' as math; // 🔥 Necesario para usar math.pi

class ShimmerBorderButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;

  const ShimmerBorderButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  State<ShimmerBorderButton> createState() => _ShimmerBorderButtonState();
}

class _ShimmerBorderButtonState extends State<ShimmerBorderButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // 🔥 Esto dispara la animación en cuanto el widget se monta
    _controller.forward();

    // Si quieres que se repita infinitamente, usa:
    // _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose(); // 🔥 Liberar recursos es importante
    super.dispose();
  }

  void _playAnimation() {
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _playAnimation();
        widget.onPressed();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            // 🔥 foregroundPainter lo dibuja POR ENCIMA del fondo, haciéndolo más visible
            foregroundPainter: _BorderPainter(progress: _controller.value),
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.black.withValues(alpha: 0.4),
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}

class _BorderPainter extends CustomPainter {
  final double progress;

  _BorderPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // 🔥 No dibujamos el borde si no hay animación
    if (progress <= 0.0 || progress >= 1.0) return;

    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(16),
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // 🔥 Gradiente rotatorio fijo
    paint.shader = SweepGradient(
      colors: const [
        Colors.transparent,
        Colors.amberAccent,
        Colors.transparent,
      ],
      stops: const [
        0.0,
        0.05, // El tamaño del destello (5% del borde)
        0.1,
      ],
      // Giramos el gradiente usando el progreso (0 a 360 grados)
      transform: GradientRotation(progress * 2 * math.pi),
    ).createShader(rect.outerRect);

    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _BorderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}