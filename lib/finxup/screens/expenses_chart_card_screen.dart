import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';

enum ChartPeriod { week, month, quarter, year }

class StatisticsScreen extends StatefulWidget {
  final List<Transaction> transactions;

  const StatisticsScreen({super.key, required this.transactions});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  ChartPeriod _selectedPeriod = ChartPeriod.month;

  // Variables para almacenar los cálculos del período actual
  double _totalSpent = 0.0;
  double _maxExpense = 0.0;
  List<FlSpot> _chartSpots = [];

  @override
  void initState() {
    super.initState();
    _processData();
  }

  // --- Lógica de Procesamiento de Datos ---
  void _processData() {
    final Map<String, double> dataMap = {};
    DateTime now = DateTime.now();
    int pointsCount;
    String dateFormat;

    switch (_selectedPeriod) {
      case ChartPeriod.week:
        pointsCount = 7;
        dateFormat = 'yyyy-MM-dd';
        break;
      case ChartPeriod.month:
        pointsCount = 30;
        dateFormat = 'yyyy-MM-dd';
        break;
      case ChartPeriod.quarter:
        pointsCount = 90;
        dateFormat = 'yyyy-MM-dd';
        break;
      case ChartPeriod.year:
        pointsCount = 12;
        dateFormat = 'yyyy-MM';
        break;
    }

    DateTime startDate = _selectedPeriod == ChartPeriod.year
        ? DateTime(now.year, now.month - 11, 1)
        : now.subtract(Duration(days: pointsCount - 1));

    double tempTotal = 0.0;
    double tempMax = 0.0;

    // Filtrar, sumar y encontrar el gasto máximo
    for (var tx in widget.transactions) {
      if (tx.category == TransactionCategory.expense && tx.date.isAfter(startDate)) {
        final key = DateFormat(dateFormat).format(tx.date);
        
        // Sumar para el gráfico
        dataMap.update(key, (v) => v + tx.monto, ifAbsent: () => tx.monto);
        
        // Sumar para el total general
        tempTotal += tx.monto;
        
        // Encontrar la transacción más alta
        if (tx.monto > tempMax) {
          tempMax = tx.monto;
        }
      }
    }

    // Convertir a Spots para el gráfico
    List<FlSpot> spots = [];
    for (int i = 0; i < pointsCount; i++) {
      DateTime pointDate;
      if (_selectedPeriod == ChartPeriod.year) {
        pointDate = DateTime(now.year, now.month - (pointsCount - 1 - i), 1);
      } else {
        pointDate = now.subtract(Duration(days: pointsCount - 1 - i));
      }

      final key = DateFormat(dateFormat).format(pointDate);
      spots.add(FlSpot(i.toDouble(), dataMap[key] ?? 0.0));
    }

    setState(() {
      _chartSpots = spots;
      _totalSpent = tempTotal;
      _maxExpense = tempMax;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Formateador de moneda para un look profesional
    final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Asegura el fondo correcto
      appBar: AppBar(
        title: const Text('Estadísticas', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            
            // 1. Selector de Periodo (Modernizado)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SegmentedButton<ChartPeriod>(
                segments: const [
                  ButtonSegment(value: ChartPeriod.week, label: Text("7D")),
                  ButtonSegment(value: ChartPeriod.month, label: Text("30D")),
                  ButtonSegment(value: ChartPeriod.quarter, label: Text("3M")),
                  ButtonSegment(value: ChartPeriod.year, label: Text("1A")),
                ],
                selected: {_selectedPeriod},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _selectedPeriod = newSelection.first;
                    _processData(); // Recalcular datos al cambiar de pestaña
                  });
                },
                style: SegmentedButton.styleFrom(
                  backgroundColor: AppTheme.surface.withOpacity(0.5),
                  selectedBackgroundColor: AppTheme.primaryWine,
                  selectedForegroundColor: Colors.white,
                  foregroundColor: Colors.white54,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            
            const SizedBox(height: 30),

            // 2. Cabecera de Total Gastado
            Column(
              children: [
                const Text(
                  'Total Gastado',
                  style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  currencyFormatter.format(_totalSpent),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.0,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 3. Tarjeta del Gráfico
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.only(top: 30, bottom: 20, left: 15, right: 25),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: SizedBox(
                height: 220,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.white.withOpacity(0.05),
                        strokeWidth: 1,
                        dashArray: [5, 5], // Líneas punteadas para un look más limpio
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: _getInterval(),
                          getTitlesWidget: (value, meta) => _buildBottomLabels(value),
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _chartSpots,
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: AppTheme.accentGold,
                        barWidth: 4, // Un poco más grueso para destacar
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.accentGold.withOpacity(0.3),
                              AppTheme.accentGold.withOpacity(0.0),
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
            ),

            const SizedBox(height: 25),

            // 4. Tarjetas de Resumen Adicionales
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      icon: Icons.trending_up_rounded,
                      title: 'Gasto Más Alto',
                      value: currencyFormatter.format(_maxExpense),
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildSummaryCard(
                      icon: Icons.analytics_outlined,
                      title: 'Promedio Diario',
                      value: currencyFormatter.format(_getDailyAverage()),
                      color: AppTheme.accentGold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40), // Espaciado final
          ],
        ),
      ),
    );
  }

  // --- Helpers UI y Lógica ---

  Widget _buildSummaryCard({required IconData icon, required String title, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  double _getInterval() {
    switch (_selectedPeriod) {
      case ChartPeriod.week: return 1;
      case ChartPeriod.month: return 6;
      case ChartPeriod.quarter: return 15;
      case ChartPeriod.year: return 2;
    }
  }

  double _getDailyAverage() {
    if (_totalSpent == 0) return 0.0;
    int days = _selectedPeriod == ChartPeriod.week ? 7 : (_selectedPeriod == ChartPeriod.month ? 30 : (_selectedPeriod == ChartPeriod.quarter ? 90 : 365));
    return _totalSpent / days;
  }

  Widget _buildBottomLabels(double value) {
    String text = "";
    DateTime now = DateTime.now();

    try {
      if (_selectedPeriod == ChartPeriod.year) {
        DateTime date = DateTime(now.year, now.month - (11 - value.toInt()), 1);
        text = DateFormat.MMM('es_ES').format(date).toUpperCase();
      } else {
        int daysToSubtract;
        switch (_selectedPeriod) {
          case ChartPeriod.week: daysToSubtract = 6; break;
          case ChartPeriod.month: daysToSubtract = 29; break;
          case ChartPeriod.quarter: daysToSubtract = 89; break;
          default: daysToSubtract = 6;
        }
        DateTime date = now.subtract(Duration(days: daysToSubtract - value.toInt()));
        text = DateFormat('dd MMM', 'es_ES').format(date); // Formato día/mes
      }
    } catch (e) {
      text = ''; // Prevenir errores si el índice sale de rango durante animaciones
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(text, style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}