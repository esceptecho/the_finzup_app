import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';

class OldExpensesChartCard extends StatelessWidget {
  final List<Transaction> transactions;

  const OldExpensesChartCard({super.key, required this.transactions});

  // 1. Lógica para procesar los datos
  List<FlSpot> _getMonthlyExpenseSpots() {
    final Map<String, double> monthlyExpenses = {};
    final DateTime sixMonthsAgo = DateTime.now().subtract(const Duration(days: 180));

    for (var tx in transactions) {
      if (tx.category == TransactionCategory.expense && tx.date.isAfter(sixMonthsAgo)) {
        final String monthKey = DateFormat('yyyy-MM').format(tx.date);
        monthlyExpenses.update(
          monthKey,
          (value) => value + tx.monto,
          ifAbsent: () => tx.monto,
        );
      }
    }

    final List<FlSpot> spots = [];
    for (int i = 0; i < 6; i++) {
      final DateTime month = DateTime(DateTime.now().year, DateTime.now().month - i);
      final String monthKey = DateFormat('yyyy-MM').format(month);
      final double totalExpense = monthlyExpenses[monthKey] ?? 0.0;
      // Invertimos el índice para que el mes más antiguo esté a la izquierda (0)
      spots.add(FlSpot((5 - i).toDouble(), totalExpense)); 
    }

    spots.sort((a, b) => a.x.compareTo(b.x));
    return spots;
  }

  // 2. Lógica para calcular el tope visual del gráfico
  double _calculateMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 1000.0;
    double maxVal = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    return maxVal > 0 ? maxVal * 1.3 : 1000.0; // Añade un 30% de aire arriba
  }

  @override
  Widget build(BuildContext context) {
    final spots = _getMonthlyExpenseSpots();
    final maxY = _calculateMaxY(spots);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título Elegante de la Tarjeta
          const Text(
            "Evolución de Gastos",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Últimos 6 meses",
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const SizedBox(height: 24),
          
          // El Gráfico
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: maxY,
                
                // Interacción elegante al tocar los puntos
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => AppTheme.primaryWine.withOpacity(0.9),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '\$${spot.y.toStringAsFixed(0)}',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      }).toList();
                    },
                  ),
                ),
                
                // Configuración de las etiquetas (Meses)
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), // Ocultamos el eje Y para más minimalismo
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final DateTime month = DateTime(
                          DateTime.now().year, 
                          DateTime.now().month - (5 - value.toInt())
                        );
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat.MMM('es_ES').format(month).capitalize(), // Ej: "Oct"
                            style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                // Cuadrícula muy sutil
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false, // Sin líneas verticales, se ve más limpio
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white.withOpacity(0.05),
                    strokeWidth: 1,
                    dashArray: [5, 5], // Línea punteada elegante
                  ),
                ),
                borderData: FlBorderData(show: false), // Sin bordes duros
                
                // La línea principal y su diseño
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppTheme.accentGold, // La línea en oro
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false), // Ocultamos los puntos hasta que se tocan
                    belowBarData: BarAreaData(
                      show: true,
                      // Efecto de luz difuminada debajo de la curva
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.accentGold.withOpacity(0.3),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Extensión rápida para capitalizar la primera letra del mes ("oct" -> "Oct")
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}