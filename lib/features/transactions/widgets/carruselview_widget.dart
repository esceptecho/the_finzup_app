// ignore_for_file: avoid_print

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:the_finzup_app/features/models/assets_image_list.dart';

class CarruselviewWidget extends StatefulWidget {
  final Function(String) onImageSelected;

  const CarruselviewWidget({super.key, required this.onImageSelected});

  @override
  State<CarruselviewWidget> createState() => _CarruselviewWidgetState();
}

class _CarruselviewWidgetState extends State<CarruselviewWidget> {
  // Ya no necesitas 'rutaSeleccionada' aquí si solo pasas el dato hacia arriba. 

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: CarouselView.weighted(
        scrollDirection: Axis.horizontal,
        flexWeights: const [1],
        // 1. Usamos la propiedad nativa onItemTap del CarouselView
        onTap: (int index) {
          String ruta = assetImageList[index].assetName;
          
          // Notificamos al padre una sola vez
          widget.onImageSelected(ruta);
          
          // Imprimimos la variable directa, no la ejecución de la función
          print('Ruta imagen enviada al padre: $ruta');
        },
        // 2. Quitamos el InkWell de los hijos
        children: List.generate(assetImageList.length, (int index) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(
                (math.Random().nextDouble() * 0xFFFFFF).toInt(),
              ).withOpacity(0.6),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(image: assetImageList[index], fit: BoxFit.cover),
            ),
          );
        }),
      ),
    );
  }
}