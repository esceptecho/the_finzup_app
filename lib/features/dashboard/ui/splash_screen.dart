import 'package:flutter/material.dart';
import 'package:the_finzup_app/features/transactions/widgets/colorize_names_widget.dart';
import 'package:the_finzup_app/finxup/theme/app_theme.dart';
import 'package:the_finzup_app/widgets/shimmer_border_wrapper.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final schemeColor = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Importante: Reduce el Column al tamaño de sus hijos
              children: [
                ShimmerBorderWrapper(
                  borderRadius: 20, // Coincide con el del Container
                  strokeWidth: 2,
                  isAnimating: true,
                  repeat: false, // Bucle infinito
                  shimmerColor: AppTheme.accentGold,
                  child: ColorizeNamesWidget(
                    names: ['F I N Z U P'],
                    colors: [
                      AppTheme.expenseRedDark,
                      AppTheme.backgroundDeepRed,
                      AppTheme.accentGoldBright,
                      AppTheme.accentGoldMuted,
                      AppTheme.accentDarkGoldMuted,
                      AppTheme.expenseRedLight,
                      AppTheme.expenseRedDark,
                    ],
                    fontSize: 32,
                  ),
                ),
              ],
            ),
          ),
                    // Container(
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(15), // Sin bordes redondeados para un look moderno
          //     border: Border.all(
          //       color: AppTheme.burgundyPrimary,
          //       width: 0.5,
          //       style: BorderStyle.solid,
          //     ), // Borde sutil para destacar el contenedor
          //   ),
            // color: AppTheme.backgroundDeep,
          // ),
        ],
      ),
    );
  }
}



// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final schemeColor = Theme.of(context).colorScheme;

//     return Scaffold(
//       body: Stack(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             gradient: RadialGradient(colors: [AppTheme.iceWhite,AppTheme.burgundyLight, AppTheme.burgundyPrimary, ])
//           ),
//           // color: AppTheme.burgundyPrimary,
//           ),

//         Center(
//           child: Column(
//             mainAxisSize: MainAxisSize
//                 .min, // Importante: Reduce el Column al tamaño de sus hijos
//             children: [
//               Text(
//                 'FI N Z U P',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 softWrap: true,
//                 textAlign: .center,
//               ),
//               SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity, // Define un ancho fijo
//                 height: 300, // Define un alto fijo
//                 child: Lottie.asset(
//                    "assets/lotties/areesie.json",
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//     );
//   }
// }