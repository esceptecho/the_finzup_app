import 'package:flutter/material.dart';

enum InsightType { positive, warning, info, goal, neutral }

class FinanceInsight {
  FinanceInsight({
    required this.title,
    required this.description,
    required this.type,
    this.isExpanded = false,
    this.actionText, // Ejemplo: "Ver presupuesto"
    this.icon,
  });

  String title;
  String description;
  InsightType type;
  bool isExpanded;
  String? actionText;
  String? icon;
}

List<FinanceInsight> get generateInsights {
  // En una app real, esto vendría de un servicio de análisis
  return [
    FinanceInsight(
      title: '¡Buen trabajo, Diego!',
      description:
          'Tu balance este mes es un 10% superior al anterior. ¡Vas por buen camino!',
      type: InsightType.positive,
      icon: '🚀',
    ),
    FinanceInsight(
      title: '¡Meta cumplida, Laura!',
      description:
          'Alcanzaste tu objetivo de ahorro para "Viaje a Japón" 2 semanas antes de lo previsto. ¡Genial!',
      type: InsightType.positive,
      icon: '🏆',
    ),

    FinanceInsight(
      title: 'Suscripciones ocultas',
      description:
          'Gastaste \$120 en servicios que no usas (Disney+, gym, Spotify). Revisa tus renovaciones.',
      type: InsightType.warning,
      actionText: 'Revisar suscripciones',
      icon: '🔁',
    ),

    FinanceInsight(
      title: 'Récord de ingresos extras',
      description:
          'Tus trabajos freelance generaron un 40% más que el mes pasado. ¡Sigue así!',
      type: InsightType.positive,
      icon: '📈',
    ),

    FinanceInsight(
      title: 'Compras por internet',
      description:
          'Llevas 8 compras en Amazon en los últimos 7 días. ¿Todas eran necesarias?',
      type: InsightType.warning,
      actionText: 'Ver historial',
      icon: '🛒',
    ),

    FinanceInsight(
      title: 'Gastos hormiga',
      description:
          'Tus cafés y snacks del día sumaron \$450 este mes. Equivale al 15% de tu presupuesto de comida.',
      type: InsightType.neutral,
      icon: '🐜',
    ),

    FinanceInsight(
      title: 'Deuda a punto de vencer',
      description:
          'Tu tarjeta de crédito vence en 3 días. Pagar después generará intereses de \$230.',
      type: InsightType.warning,
      actionText: 'Pagar ahora',
      icon: '⏰',
    ),

    FinanceInsight(
      title: 'Inversión inteligente',
      description:
          'Tu fondo de emergencia ya generó \$85 en intereses este año. ¡Mejor que tenerlo quieto!',
      type: InsightType.positive,
      icon: '🌱',
    ),

    FinanceInsight(
      title: 'Comida fuera de control',
      description:
          'El rubro "Restaurantes" superó en un 70% tu objetivo mensual. Quedan 10 días.',
      type: InsightType.warning,
      actionText: 'Reducir gastos',
      icon: '🍽️',
    ),

    FinanceInsight(
      title: 'Primer mes sin deudas',
      description:
          '¡Felicitaciones! No registras saldo pendiente en ninguna tarjeta por primera vez en 6 meses.',
      type: InsightType.positive,
      icon: '🎉',
    ),

    FinanceInsight(
      title: 'Comparativa anual',
      description:
          'En septiembre gastaste un 12% menos que el año pasado. Tu poder de ahorro aumentó.',
      type: InsightType.positive,
      icon: '📉',
    ),
    FinanceInsight(
      title: 'Presupuesto de Ocio',
      description:
          'Has consumido el 90% de tu presupuesto para salidas. ¡Cuidado con el fin de semana!',
      type: InsightType.warning,
      actionText: 'Ajustar presupuesto',
      icon: '⚠️',
    ),
  ];
}

class ExpansionPanelFinanceInsight extends StatefulWidget {
  const ExpansionPanelFinanceInsight({super.key});

  @override
  State<ExpansionPanelFinanceInsight> createState() =>
      _ExpansionPanelFinanceInsightState();
}

class _ExpansionPanelFinanceInsightState
    extends State<ExpansionPanelFinanceInsight> {
  // Usamos nuestra nueva lista de Insights
  final List<FinanceInsight> _data = generateInsights;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      elevation: 3,
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((FinanceInsight insight) {
        // Definimos el color según el tipo para la UI
        final Color typeColor = _getInsightColor(insight.type);

        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: Text(
                insight.icon ?? '💡',
                style: const TextStyle(fontSize: 24),
              ),
              title: Text(
                insight.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isExpanded ? typeColor : Colors.white70,
                ),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.description,
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (insight.actionText != null)
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            /* Navegar a la acción */
                          },
                          child: Text(
                            insight.actionText!,
                            style: TextStyle(color: typeColor),
                            overflow: .fade,
                            // softWrap: true,
                          ),
                        ),
                      ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _data.removeWhere((item) => item == insight);
                          if (_data.isEmpty) {
                            Navigator.pop(context);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          isExpanded: insight.isExpanded,
        );
      }).toList(),
    );
  }

  // Método auxiliar para colores semánticos
  Color _getInsightColor(InsightType type) {
    switch (type) {
      case InsightType.positive:
        return Colors.green.shade700;
      case InsightType.warning:
        return Colors.orange.shade800;
      case InsightType.goal:
        return Colors.blue.shade700;
      case InsightType.info:
        return Colors.blueGrey;
      case InsightType.neutral:
        return Colors.yellow;  
    }
  }
}
