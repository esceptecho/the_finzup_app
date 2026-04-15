// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:the_finzup_app/features/dashboard/ui/app_colors.dart';
import 'package:the_finzup_app/features/dashboard/ui/home_page.dart';
import 'package:the_finzup_app/features/dashboard/widgets/fact_segment_button.dart';
import 'package:the_finzup_app/features/dashboard/widgets/grafico_cotizacion.dart';
import 'package:the_finzup_app/features/dashboard/widgets/segment_button.dart';
import 'package:the_finzup_app/features/models/fake_transactions.dart';
import 'package:the_finzup_app/features/models/transaction.dart'
    hide Transaction;
import 'package:the_finzup_app/features/transactions/widgets/build_action_card.dart';
import 'package:the_finzup_app/features/transactions/widgets/carruselview_widget.dart';
import 'package:the_finzup_app/finxup/models/transaction.dart';
import 'package:the_finzup_app/finxup/screens/new_home_screen.dart';
import 'package:the_finzup_app/finxup/theme/app_theme.dart';
import 'package:the_finzup_app/widgets/navigaton_drawer.dart';
import 'package:intl/intl.dart'; // Para formatear fechas y nombres de meses

final List<FlSpot> datosPrueba = [
  const FlSpot(0, 10.5),
  const FlSpot(1, 15.2),
  const FlSpot(2, 12.8),
  const FlSpot(3, 22.5),
  const FlSpot(4, 18.0),
  const FlSpot(5, 25.4),
  const FlSpot(6, 30.0),
];

class HomePge extends StatefulWidget {
  const HomePge({super.key});

  @override
  State<HomePge> createState() => _HomePgeState();
}

class _HomePgeState extends State<HomePge> {
  bool isInvoice = true;
  bool isChecked = false; // 1. Definir la variable de estado
  late List<AssetImage> assetImageList;
  String? rutaImagen;
  final List<Transaction> _transactions = [];

  // ... (en tu _NewHomeScreenState) ...

  List<FlSpot> _getMonthlyExpenseSpots(List<Transaction> transactions) {
    // Mapa para agrupar gastos por mes (key: "YYYY-MM", value: total_gasto)
    final Map<String, double> monthlyExpenses = {};

    // Calcular la fecha de inicio (ej: 6 meses atrás)
    final DateTime sixMonthsAgo = DateTime.now().subtract(
      const Duration(days: 180),
    );

    // Recorrer transacciones y sumar gastos por mes
    for (var tx in transactions) {
      if (tx.category == TransactionCategory.expense &&
          tx.date.isAfter(sixMonthsAgo)) {
        // Formatear la fecha a "YYYY-MM" para agrupar
        final String monthKey = DateFormat('yyyy-MM').format(tx.date);
        monthlyExpenses.update(
          monthKey,
          (value) => value + tx.monto, // Suma el monto si ya existe
          ifAbsent: () => tx.monto, // Si no existe, lo añade
        );
      }
    }

    // Generar los FlSpot
    final List<FlSpot> spots = [];
    int monthIndex = 0; // El valor 'x' del FlSpot

    // Iterar por los últimos 6 meses (para asegurar que el eje X sea continuo)
    for (int i = 0; i < 6; i++) {
      final DateTime month = DateTime(
        DateTime.now().year,
        DateTime.now().month - i,
      );
      final String monthKey = DateFormat('yyyy-MM').format(month);

      final double totalExpense =
          monthlyExpenses[monthKey] ?? 0.0; // 0 si no hay gastos

      // Queremos que los meses más antiguos tengan un 'x' más bajo
      // y los más recientes un 'x' más alto para que el gráfico fluya de izquierda a derecha
      spots.add(FlSpot(monthIndex.toDouble(), totalExpense));
      monthIndex++;
    }

    // Ordenar los spots por su valor 'x' para que el gráfico sea correcto
    spots.sort((a, b) => a.x.compareTo(b.x));

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    // Detectamos si el sistema está en modo oscuro o claro
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      floatingActionButton: IconButton.filled(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewHomeScreen()),
          );
        },
        icon: Icon(Icons.home_outlined),
      ),
      endDrawer: NavigatonDrawer(),
      // Usamos el gris profundo para el fondo en modo oscuro
      backgroundColor: isDarkMode
          ? AppColors.color0af0f0ff
          : AppColors.iceWhite,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // --- AppBar Elegante ---
              SliverAppBar(
                backgroundColor: AppColors.burgundyPrimary,
                // Usamos Padding para separar el avatar de los bordes del AppBar
                leading: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                  ), // Un poco de aire a la izquierda
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(transactions: []),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 20, // El tamaño del borde exterior
                      backgroundColor: Colors.white.withOpacity(
                        0.5,
                      ), // Color del anillo (blanco translúcido)
                      child: CircleAvatar(
                        radius:
                            19, // El tamaño del avatar real (un poco más pequeño)
                        backgroundColor: AppColors.burgundyPrimary,
                        backgroundImage:
                            (rutaImagen != null && rutaImagen!.isNotEmpty)
                            ? AssetImage(rutaImagen!)
                            : null,
                        child: (rutaImagen == null || rutaImagen!.isEmpty)
                            ? const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 18,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),

                title: const Text(
                  'F I N Z U P',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                centerTitle: true,
                expandedHeight: 300,
                floating: true,
                pinned: false, // Mantiene una barra visible al hacer scroll
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.burgundyPrimary,
                          AppColors.color0ff0f0ff, // Transición al gris oscuro
                        ],
                      ),
                    ),
                    child: Opacity(
                      opacity: 0.2,
                      child: Card.outlined(
                        color: Color(
                          (math.Random().nextDouble() * 0xFFFFFF).toInt(),
                        ).withOpacity(0.6),
                      ),
                    ),
                  ),
                  title: !isInvoice
                      ? Container(
                          height: 120,
                          decoration: isInvoice
                              ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      const Color.fromARGB(121, 255, 82, 82),
                                      const Color.fromARGB(127, 255, 86, 34),
                                      const Color.fromARGB(124, 233, 30, 98),
                                    ],
                                  ),
                                )
                              : BoxDecoration(
                                  // border: Border.all(),
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      const Color.fromARGB(121, 91, 80, 47),
                                      const Color.fromARGB(125, 49, 105, 135),
                                      const Color.fromARGB(121, 6, 11, 19),
                                    ],
                                  ),
                                ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: .center,
                              children: [
                                Text(
                                  'Balance',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: .w400,
                                  ),
                                ),

                                Text(
                                  '\$70,000',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: .w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: Container(
                            padding: EdgeInsets.only(top: 100),
                            width: double.infinity, // Define un ancho fijo
                            height: 50, // Define un alto fijo
                            child: Icon(Icons.bar_chart_sharp, size: 40,),
                          ),
                        ),
                  centerTitle: true,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const .only(top: 20, right: 20, left: 20),
                  padding: const .symmetric(horizontal: 8, vertical: 8),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.color0efffaff,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SegmentButton(
                          title: 'Movimientos',
                          isActive: isInvoice,
                          onPressed: () {
                            setState(() {
                              isInvoice = !isInvoice;
                            });
                          },
                        ),
                      ),

                      Expanded(
                        child: SegmentButton(
                          title: 'Facturas',
                          isActive: !isInvoice,
                          onPressed: () {
                            setState(() {
                              isInvoice = !isInvoice;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // --Color.fromARGB(42, 255, 255, 255)rd de Crédito / Principal ---
              if (!isInvoice)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 300,
                    child: ListView(
                      padding: EdgeInsets.all(20),
                      // physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        FactSegmentButton(
                          title: 'University',
                          onPressed: () {},
                          isActive: true,
                          icon: Icons.school_outlined,
                        ),
                        const SizedBox(height: 10),
                        FactSegmentButton(
                          title: 'Clases de canto',
                          onPressed: () {},
                          isActive: true,
                          icon: Icons.record_voice_over,
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 10),
                        FactSegmentButton(
                          title: 'Clases de portugues',
                          onPressed: () {},
                          isActive: true,
                          icon: Icons.language_rounded,
                        ),
                        const SizedBox(height: 10),
                        FactSegmentButton(
                          title: 'Soccer',
                          onPressed: () {},
                          isActive: true,
                          icon: Icons.sports_soccer,
                        ),
                        const SizedBox(height: 10),
                        FactSegmentButton(
                          title: 'Aleman',
                          onPressed: () {},
                          isActive: true,
                          icon: Icons.language_sharp,
                        ),
                      ],
                    ),
                  ),
                ),
              if (isInvoice) SliverToBoxAdapter(child: SizedBox(height: 20)),
              if (isInvoice)
                SliverToBoxAdapter(
                  child: Container(
                    height: 150,
                    color: Colors.transparent,
                    child: buildQuickActions(),
                  ),
                ),
              if (!isInvoice) SliverToBoxAdapter(child: SizedBox(height: 40)),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // ... tus otros widgets ...
                    SizedBox(
                      height: 200, // Altura para el gráfico),
                    )
                  ],
                ),
              ),
              if (isInvoice)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 250,
                        color: AppColors.color0ff0f0ff, // Gris casi negro
                        child: Center(
                          child: Icon(
                            Icons.bar_chart,
                            color: AppColors.burgundyLight,
                            size: 70,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isInvoice)
                SliverToBoxAdapter(child: const SizedBox(height: 20)),

              if (isInvoice)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0.0,
                      vertical: 24,
                    ),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.color0af0f0ff, // Tu gris neutro oscuro
                        borderRadius: BorderRadius.circular(0),
                        border: Border.all(
                          color: AppColors.burgundyLight.withOpacity(0.1),
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(12),
                          child: Stack(
                            children: [
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (isInvoice)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: AppColors.cardBgColor, // Vino tinto
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Lottie.asset(
                          "assets/lotties/Secure-Payment-Card.json",
                          fit: BoxFit.contain,
                          repeat: false,
                        ),
                      ),
                    ),
                  ),
                ),
              // --- Sección 2: Contenedor de Información (Gris Neutro) ---
              

              // --- Sección 3: Otros Contenedores ---
              if (!isInvoice)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 80,
                    child: ListTile(
                      leading: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.dashboard_customize_outlined,
                          size: 32,
                        ),
                      ),
                      trailing: ActionChip.elevated(
                        label: Text('Date', style: TextStyle(fontSize: 16)),
                        avatar: Icon(Icons.calendar_month_rounded, size: 32),
                      ),
                    ),
                  ),
                ),
              // if (!isInvoice) SliverToBoxAdapter(child: const SizedBox(height: 20)),
              if (!isInvoice)
                SliverToBoxAdapter(
                  child: // En la pantalla donde está el Carrusel:
                      // 2. EL CARRUSEL: Le pasamos la función para "subir" el estado
                      CarruselviewWidget(
                        //
                        onImageSelected: (nuevaRuta) {
                          setState(() {
                            rutaImagen = nuevaRuta;
                          });
                          print("Estado actualizado en el Padre: $rutaImagen");
                        },
                      ),
                ),
              if (isInvoice)
                SliverToBoxAdapter(child: const SizedBox(height: 20)),
            ],
          ),
          // CAPA 2: El Sheet "desechable" o deslizable
          DraggableScrollableSheet(
            initialChildSize: 0.1, // Solo asoma un poco al inicio
            minChildSize: 0.05, // Casi invisible si se baja todo
            maxChildSize: 0.9, // No tapa toda la pantalla (opcional)
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.cardBgColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio:
                        1.0, // Ajusta esto para que el card no se vea estirado
                  ),
                  // ¡CRUCIAL!: Usa el controller que te da el builder
                  controller: scrollController,
                  itemCount: mockTransactions.length,
                  itemBuilder: (context, index) {
                    final tx = mockTransactions[index];
                    final isExpense =
                        tx.category.type == TransactionType.expense;
                    return InkWell(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icono con fondo circular
                              CircleAvatar(
                                backgroundColor:
                                    (isExpense
                                            ? Colors.red.shade700
                                            : Colors.green.shade700)
                                        .withOpacity(0.1),
                                child: Icon(
                                  IconData(
                                    tx.category.iconCodePoint,
                                    fontFamily: 'MaterialIcons',
                                  ),
                                  color: isExpense
                                      ? Colors.red.shade700
                                      : Colors.green.shade700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                tx.description,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.greyText,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                tx.category.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const Divider(color: AppColors.dividerColor),
                              Text(
                                '\$${tx.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isExpense
                                      ? Colors.red.shade700
                                      : Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildQuickActions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: Colors.transparent, // Formato hexadecimal más limpio
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('Acciones Rápidas', style: TextStyle(fontSize: 14)),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BuildActionCard(
                      icon: Icons.arrow_upward,
                      title: 'Enviar',
                      onTap: () {},
                    ),
                    BuildActionCard(
                      icon: Icons.arrow_downward,
                      title: 'Recibir',
                      onTap: () {},
                    ),
                    BuildActionCard(
                      icon: Icons.account_balance_wallet,
                      title: 'Invertir',
                      onTap: () {},
                    ),
                    BuildActionCard(
                      icon: Icons.payment_outlined,
                      title: 'Mis Tarjetas',
                      onTap: () {},
                    ),
                    BuildActionCard(
                      icon: Icons.payments_outlined,
                      title: 'Retirar',
                      onTap: () {},
                    ),
                    BuildActionCard(
                      icon: Icons.public_rounded,
                      title: 'Global Inv',
                      onTap: () {
                        print("Invertiendo");
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

