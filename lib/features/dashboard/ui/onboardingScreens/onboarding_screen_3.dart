import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.cyan),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Importante: Reduce el Column al tamaño de sus hijos
            children: [
              Text(
                'y tus pagos están seguros',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                softWrap: true,
                textAlign: .center,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity, // Define un ancho fijo
                height: 300, // Define un alto fijo
                child: Lottie.asset(
                   "assets/lotties/Secure-Payment-Card.json",
                  fit: BoxFit.contain,
                  repeat: false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
