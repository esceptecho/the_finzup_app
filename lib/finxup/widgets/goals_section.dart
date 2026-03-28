import 'package:flutter/material.dart';
import 'package:the_finzup_app/finxup/models/goal.dart';
import 'package:the_finzup_app/finxup/theme/app_theme.dart';
import 'package:the_finzup_app/finxup/widgets/goal_card.dart';

class GoalsSection extends StatelessWidget {
  final List<Goal> goals;
  final VoidCallback onAddTap; // <--- Nuevo callback
  final Function(String) onDelete;
  final Function(Goal) onAddMoney;

  const GoalsSection({
    super.key,
    required this.goals,
    required this.onAddTap,
    required this.onDelete,
    required this.onAddMoney,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  goals.isNotEmpty ? "Mis Metas" : "Agregar Metas",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    size: 28,
                    color: AppTheme.accentGold,
                  ),
                  onPressed: onAddTap, // <--- Abre el modal de metas
                ),
              ],
            ),
          ),
          // ... resto del L-iew.builder
          goals.isNotEmpty
              ? SizedBox(
                  height: 160, // Altura del carrusel
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      final goal = goals[index];
                      return GestureDetector(
                        onLongPress: () => onDelete(
                          goal.id,
                        ), // <-- Aquí enviamos el ID al padre
                        onTap: () => onAddMoney(goal),
                        child: GoalCard(goal: goal),
                      );
                    },
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
