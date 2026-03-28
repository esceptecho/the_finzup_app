import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.deepPurpleAccent),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Importante: Reduce el Column al tamaño de sus hijos
            children: [
              Text(
                'Administra tus movimientos financieros',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                softWrap: true,
                textAlign: .center,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity, // Define un ancho fijo
                height: 300, // Define un alto fijo
                child: Lottie.asset(
                  "assets/lotties/wallet.json",
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
