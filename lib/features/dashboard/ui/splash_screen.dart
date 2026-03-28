import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:the_finzup_app/features/dashboard/ui/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final schemeColor = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(colors: [AppColors.iceWhite,AppColors.burgundyLight, AppColors.burgundyPrimary, ])
          ),
          // color: AppColors.burgundyPrimary,
          ),

        Center(
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Importante: Reduce el Column al tamaño de sus hijos
            children: [
              Text(
                'FI N Z U P',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                softWrap: true,
                textAlign: .center,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity, // Define un ancho fijo
                height: 300, // Define un alto fijo
                child: Lottie.asset(
                   "assets/lotties/areesie.json",
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    );
  }
}