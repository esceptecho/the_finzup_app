// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_finzup_app/features/dashboard/ui/app_colors.dart';
import 'package:the_finzup_app/features/dashboard/ui/login_screen.dart';
import 'package:the_finzup_app/features/dashboard/ui/onboardingScreens/onboarding_screen.dart';
import 'package:the_finzup_app/features/dashboard/ui/splash_screen_wrapper.dart';
import 'package:the_finzup_app/features/dashboard/ui/widget072.dart';
import 'package:the_finzup_app/features/models/fake_transactions.dart';
import 'package:the_finzup_app/features/transactions/ui/credit_card_selection.dart';
import 'package:the_finzup_app/features/transactions/ui/transaction_screen.dart';
import 'package:the_finzup_app/features/transactions/widgets/add_card_sheet.dart';
import 'package:the_finzup_app/finxup/screens/new_home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ESTA ES LA LÍNEA QUE FALTA:
  await initializeDateFormatting('es_ES', null);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finxup App',
      debugShowCheckedModeBanner: false, // Oculta el banner de debug
      // --- TEMA CLARO (Modernizado) ---
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.burgundyPrimary,
        scaffoldBackgroundColor: AppColors.iceWhite,
        fontFamily: 'Montserrat',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.burgundyPrimary,
          primary: AppColors.burgundyPrimary,
          secondary: AppColors.burgundyLight,
          surface: AppColors.white,
          onPrimary: Colors.white, // Texto sobre botones vino
        ),
        // Mejora visual para tarjetas en modo claro
        cardTheme: const CardThemeData(
          color: AppColors.white,
          elevation: 2,
          shadowColor: Colors.black12,
        ),
      ),

      // --- TEMA OSCURO (Modernizado) ---
      darkTheme: ThemeData(
        useMaterial3: true,
        // El fondo base ahora es el gris más oscuro para dar profundidad
        scaffoldBackgroundColor: AppColors.color0ff0f0ff,
        fontFamily: 'Montserrat',

        colorScheme: const ColorScheme.dark(
          primary:
              AppColors.burgundyPrimary, // El vino tinto como color de marca
          secondary: AppColors.burgundyLight,

          // Superficie principal (Tarjetas, Menús, Bottom Sheets)
          surface: AppColors.color0efffaff,

          onPrimary: AppColors.white,
          onSurface: AppColors.white,
        ),

        // Configuración de AppBar para que se mezcle con el fondo
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.color0ff0f0ff,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.white,
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Forzamos que las tarjetas usen el gris de elevación
        cardTheme: CardThemeData(
          color: AppColors.color0efffaff,
          elevation:
              0, // En modo oscuro moderno la elevación se da por color, no sombra
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        // Estilo de los iconos
        iconTheme: const IconThemeData(color: AppColors.white),
      ),

      // Esto permite que la app cambie según la config. del sistema
      themeMode: ThemeMode.system,

      initialRoute: '/', // La ruta inicial es el splash screen
      routes: {
        '/': (context) =>
            SplashScreenWrapper(), // Usamos un wrapper para la lógica de splash
        '/login': (context) => LoginScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/home': (context) => NewHomeScreen(),
      },
    );
  }
}

class HomeMainScreen extends StatelessWidget {
  const HomeMainScreen({super.key});

  void _showAddCardModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // useSafeArea: true,
      isScrollControlled: true, // Crucial para que el modal suba con el teclado
      backgroundColor: const Color.fromARGB(
        255,
        34,
        27,
        27,
      ), // bottomsheet color
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => const AddCardSheet(),
      // builder: (context) => MySample(),
    );
  }

  void navigateToGrid(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // Aquí pasamos los datos mock que creamos antes
        builder: (context) => TransactionGrid(transactions: mockTransactions),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ClipRRect(
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/avatar_placeholder.jpeg'),
          ),
        ),
        actions: [
          IconButton.outlined(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // Aquí pasamos los datos mock que creamos antes
                  builder: (context) =>
                      // MySample(), // Credit Card example
                      Widget072(), // colored tile-grid
                ),
              );
            },
            icon: Icon(Icons.payment),
          ),
          IconButton(
            onPressed: () => _showAddCardModal(context),
            icon: Icon(Icons.payments_rounded, size: 28),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // Aquí pasamos los datos mock que creamos antes
                  builder: (context) =>
                      TransactionGrid(transactions: mockTransactions),
                ),
              );
            },
            icon: Icon(Icons.monetization_on_sharp, size: 28),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF121212),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/icons/buho-silueta-mini.jpg',
                ), // 'assets/images/icons/buho-silueta-mini.jpg' fondo-simple0
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color.fromARGB(153, 0, 0, 0),
                  BlendMode.darken,
                ),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Balance Total',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    Text(
                      '\$24,500.00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 350, child: CardSelectionUI()),
        ],
      ),
    );
  }
}
