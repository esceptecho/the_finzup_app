import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:the_finzup_app/features/models/assets_image_list.dart';

class CarruselGoalsView extends StatefulWidget {
  final Function(String) onImageSelected;
  const CarruselGoalsView({super.key, required this.onImageSelected});

  @override
  State<CarruselGoalsView> createState() => _CarruselGoalsViewState();
}

class _CarruselGoalsViewState extends State<CarruselGoalsView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: CarouselView.weighted(
        scrollDirection: Axis.vertical,
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
        children: List.generate(goalBannerList.length, (int index) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(
                (math.Random().nextDouble() * 0xFFFFFF).toInt(),
              ).withOpacity(0.6),
            ),
            child: SingleChildScrollView(
              scrollDirection: .vertical,
              child: Column(
                children: [...goalBannerList, const SizedBox(height: 12)],
              ),
            ),
          );
        }),
      ),
    );
  }

  // Movimos la lista adentro del State para inicializarla correctamente
  final List<Widget> goalBannerList = [
    // Bloque 1: Meta Mensual
    _banner(
      Icons.savings,
      'Meta mensual: \$500 ahorrados 💰 ',
      'assets/images/finanzas-personales.png', // Usando tu asset
      Colors.deepPurple,
    ),

    // Bloque 2: Pago de Servicios
    _banner(
      Icons.timer,
      'Paga tus servicios antes del 30 ⏰ ',
      'assets/images/joven-comoda.png', // Usando tu asset
      Colors.orange,
    ),

    // Bloque 3: Meta para Jubilación
    _banner(
      Icons.account_balance,
      'Plan de jubilación 👵👴 ',
      'assets/images/jubilados-ancianos.png', // Usando tu asset
      Colors.teal,
    ),

    // Bloque 4: Gastos Estudiantiles
    _banner(
      Icons.school,
      'Inversión para estudios 📚 ',
      'assets/images/student.png', // Usando tu asset
      Colors.blueGrey,
    ),

    // Bloque 5: Fondo de Vacaciones
    _banner(
      Icons.beach_access,
      'Ahorro para vacaciones 🏖️',
      'assets/images/vacaciones.png', // Usando tu asset
      Colors.lightBlue,
    ),

    // Bloque 6: Fondo de Lujo
    _banner(
      Icons.diamond,
      'Inversión para vida lujosa 💎',
      'assets/images/vida-lujosa.png', // Usando tu asset
      Colors.amber,
    ),

    // Bloque 7: Reglas Financieras
    _banner(
      Icons.policy,
      'Mis reglas financieras 📋 ',
      'assets/diseño-reglas-financiera.png', // Usando tu asset
      Colors.indigo,
    ),

    // Bloque 8: Flujo de App
    _banner(
      Icons.insights,
      'Flujo de la aplicación 📊 ',
      'assets/dev-app-flow.png', // Usando tu asset
      Colors.green,
    ),

    // Bloque 9: Galería de Reglas
    _banner(
      Icons.photo_library,
      'Galería de reglas 🖼️ ',
      'assets/galery-de-reglas-financiera.png', // Usando tu asset
      Colors.pink,
    ),

    // Bloque 10: Logo de la App
    _banner(
      Icons.star,
      'Conoce nuestra app ✨',
      'assets/logo.png', // Usando tu asset
      Colors.purple,
    ),

    // Bloque 11: Avatar por Defecto
    _banner(
      Icons.person,
      'Perfil de usuario 👤',
      'assets/avatar_placeholder.jpeg', // Usando tu asset
      Colors.brown,
    ),

    // Bloque 12: Otro Avatar por Defecto (si quieres usar el .png también)
    _banner(
      Icons.account_circle,
      'Comunidad financiera 👥 ',
      'assets/avatar_placeholder.jpeg', // Usando tu asset
      Colors.redAccent,
    ),
  ];

  // Banner reutilizable estático con estilo personalizado
  static Widget _banner(
    IconData? icon,
    String text,
    String? imagePath,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 5, child: Icon(icon, color: Colors.white, size: 24)),
          const SizedBox(width: 24),
          Expanded(
            flex: 150,
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 45,
            child: imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      height: 80, // Reducido para que no rompa el contenedor
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
