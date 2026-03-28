// N. del autor: Este es el widget dedicado a mostrar el gráfico de líneas.
// Lo hemos extraído a su propio archivo para mantener el código limpio y reutilizable.
// Usa el paquete 'fl_chart', así que asegúrate de tenerlo en tu pubspec.yaml
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoCotizacion extends StatelessWidget {
  final List<FlSpot> datos;
  final Color lineColor;

  const GraficoCotizacion({
    super.key,
    required this.datos,
    this.lineColor = Colors.white54,
  });

  @override
  Widget build(BuildContext context) {
    // N. del autor: MEJORA DE ROBUSTEZ.
    // Si la lista de datos está vacía, no intentamos dibujar un gráfico.
    // En su lugar, mostramos un mensaje claro al usuario. Esto previene errores.
    if (datos.isEmpty) {
      return const Center(
        child: Text(
          'No hay datos disponibles para el gráfico.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: LineChart(
        LineChartData(
          // N. del autor: Configuración visual del gráfico para un look moderno.
          gridData: FlGridData(
            show: false, // leneas de referencia de precios
            drawVerticalLine: false, // malla del grafico
            getDrawingHorizontalLine: (value) {
              return FlLine(color: Colors.white12, strokeWidth: 1);
            },
            getDrawingVerticalLine: (value) {
              return FlLine(color: Colors.white12, strokeWidth: 1);
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), // Ocultamos los timestamps por ahora
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30, // Espacio para los números
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0), // Muestra el precio sin decimales
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.left,
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true, border: Border.all(color: Colors.white12)),
          minX: datos.first.x,
          maxX: datos.last.x,
          lineBarsData: [
            LineChartBarData(
              spots: datos,
              isCurved: true,
              color: lineColor,
              barWidth: 1,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: lineColor.withOpacity(0.2),                                                                                        
              ),
            ),
          ],
        ),
      ),
    );
  }
}